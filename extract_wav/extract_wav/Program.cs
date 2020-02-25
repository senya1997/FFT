using System;
using System.IO;
using System.Runtime.InteropServices;

namespace WavFormatCSharp
{
    class Program
    {
        static byte[] GetWave(String wavePath)
        {
            FileStream WaveFile = File.OpenRead(wavePath);
            byte[] wave = new byte[WaveFile.Length + 1];
            //for (int i = 0; i <= WaveFile.Length - 45; i++) wave[i] = 0; // init

            WaveFile.Read(wave, 0, Convert.ToInt32(WaveFile.Length));
            WaveFile.Close();
            return wave;
        }
        static byte[] GetWaveData(String wavePath)
        {
            int num = 0;
            int size = 0;
            FileStream WaveFile = File.OpenRead(wavePath);
            byte[] wave = new byte[WaveFile.Length + 1];
            WaveFile.Read(wave, 0, Convert.ToInt32(WaveFile.Length)); // read the wave file into the wave variable

            for (int i = 0; i <= wave.Length; i++) // if recieved exception - chunk id was not reached
            {   //            0x64                 0x61                0x74                 0x61
                if (wave[i] == 100 & wave[i + 1] == 97 & wave[i + 2] == 116 & wave[i + 3] == 97)
                {
                    num = i + 8; // avoid "chunk data size"
                    size = (wave[i + 7] << 24) |
                           (wave[i + 6] << 16) |
                           (wave[i + 5] << 8) |
                            wave[i + 4];
                    break;
                }
            }
            byte[] data = new byte[size - num + 1];

            for (int i = 0; i <= size - num; i++) data[i] = 0; // init
            for (int i = 0; i <= size - num; i++) data[i] = wave[i + num];

            WaveFile.Close();
            return data;
        }
        static byte[] GetWaveHead(String wavePath)
        {
            /*
                 0 - compression code
                 1 - number of channels
                 2,3,4,5 - sample rate (desc freq)
                 6 - significant bit per sample (bit sample)
             */
            int num = 0;
            FileStream WaveFile = File.OpenRead(wavePath);
            byte[] wave = new byte[WaveFile.Length + 1];
            byte[] head = new byte[7];

            WaveFile.Read(wave, 0, Convert.ToInt32(WaveFile.Length)); // read the wave file into the wave variable
            for(int i = 0; i <= wave.Length - 3; i++) // if recieved exception - chunk id was not reached
            {   //            0x66               0x6D                 0x74                 0x20
                if (wave[i] == 102 & wave[i+1] == 109 & wave[i + 2] == 116 & wave[i + 3] == 32)
                {
                    num = i + 8; // avoid "cunk data size"
                    break;
                }
            }
            
            head[0] = wave[num];
            
            head[1] = wave[num + 2];

            head[2] = wave[num + 7];
            head[3] = wave[num + 6];
            head[4] = wave[num + 5];
            head[5] = wave[num + 4];
            
            head[6] = wave[num + 14];
            
            WaveFile.Close();
            return head;
        }

        static void Main(string[] args)
        {
            int j = 0;
            int ch, bit_sample, freq;
            string ans;
            string file_name;

new_hex:    Console.WriteLine("\nEnter wav file name:");
            file_name = Console.ReadLine();
            byte[] buffer_data = GetWaveData(file_name + ".wav"); ;
            byte[] buffer_head = GetWaveHead(file_name + ".wav");
            
            ch = buffer_head[1];
            bit_sample = buffer_head[6];
            freq = (buffer_head[2] << 24) | (buffer_head[3] << 16) | (buffer_head[4] << 8) | buffer_head[5];

            FileStream file_hex = new FileStream(file_name + ".hex", FileMode.Create);
            StreamWriter sw_hex = new StreamWriter(file_hex);
            file_hex.Seek(0, SeekOrigin.Begin);
            
            // output to console main parameters:
            Console.WriteLine("\nSample rate: {0}", freq);
            Console.WriteLine("Channels: {0}", ch);
            Console.WriteLine("Compression code: {0}", buffer_head[0]);
            Console.WriteLine("Bits per sample: {0}\n", bit_sample);

            // head wave file to hex file:
            sw_hex.WriteLine(buffer_head[0].ToString("X2"));
            sw_hex.WriteLine(ch.ToString("X2"));
            sw_hex.WriteLine(freq.ToString("X8"));
            sw_hex.WriteLine(bit_sample.ToString("X2"));

            // write data in file for matlab:
            while (j < buffer_data.Length)
            {
                string str_temp = null;

                switch (bit_sample)
               {
                  case 16:
                       {
                            str_temp = buffer_data[j + 1].ToString("X2") +
                                         buffer_data[j].ToString("X2");

                            sw_hex.WriteLine(str_temp);
                            j = j + 2;
                            break;
                        }
                  case 24:
                        {
                            str_temp = buffer_data[j + 2].ToString("X2") +
                                         buffer_data[j + 1].ToString("X2") +
                                         buffer_data[j].ToString("X2");

                            sw_hex.WriteLine(str_temp);
                            j = j + 3;
                            break;
                        }
                  case 32:
                        {
                            str_temp = buffer_data[j + 3].ToString("X2") +
                                         buffer_data[j + 2].ToString("X2") +
                                         buffer_data[j + 1].ToString("X2") +
                                         buffer_data[j].ToString("X2");

                            sw_hex.WriteLine(str_temp);
                            j = j + 4;
                            break;
                        }
                  default:
                        {
                            sw_hex.WriteLine("\nERROR sample rate\n");
                            Console.WriteLine("\nERROR sample rate\n");
                            j = buffer_data.Length;
                            break;
                        }
                }

                if (j > buffer_data.Length - 4) j = buffer_data.Length;
                if (j >= buffer_data.Length) sw_hex.Write(str_temp); // avoid empty string in the end of file
            }

            j = 0;
            sw_hex.Close();
            file_hex.Close();

            // convert to mono:
            if (ch == 2)
            {
                int hex_size = File.ReadAllLines(file_name + ".hex").Length;

                FileStream file_mono = new FileStream(file_name + "_mono.hex", FileMode.Create);
                FileStream _file_hex = new FileStream(file_name + ".hex", FileMode.Open);
                StreamWriter sw_mono = new StreamWriter(file_mono);
                StreamReader sr_hex = new StreamReader(_file_hex);
                file_mono.Seek(0, SeekOrigin.Begin);
                _file_hex.Seek(0, SeekOrigin.Begin);

                for (int i = 0; i <= 3; i++) sw_mono.WriteLine(sr_hex.ReadLine());
                for (int i = 4; i <= hex_size - 1; i = i + 2)
                {
                    sr_hex.ReadLine();
                    sw_mono.WriteLine(sr_hex.ReadLine());
                }

                switch(bit_sample)  // for avoid empty string in the end of file
                {
                    case 16:
                        {
                            sw_mono.Write("0000");
                            break;
                        }
                    case 24:
                        {
                            sw_mono.Write("000000");
                            break;
                        }
                    case 32:
                        {
                            sw_mono.Write("00000000");
                            break;
                        }
                    default:
                        {
                            sw_mono.Write("\nERROR sample rate\n");
                            Console.WriteLine("\nERROR sample rate\n");
                            break;
                        }
                }
                    
                Console.WriteLine("Create hex in mono\n");
                
                sw_mono.Close();
                //sr_hex.Close();
                _file_hex.Close();
                file_mono.Close();
            }
            else if(ch != 1) Console.WriteLine("\nERROR number of channels\n");

            // convert to 16 bit:
            if (bit_sample != 16)
            {
                int hex_size;
                string str;

                FileStream file_16bit = new FileStream(file_name + "_16bit.hex", FileMode.Create);
                FileStream _file_hex;

                if (File.Exists(file_name + "_mono.hex"))
                {
                    hex_size = File.ReadAllLines(file_name + "_mono.hex").Length;
                    _file_hex = new FileStream(file_name + "_mono.hex", FileMode.Open);
                }
                else
                {
                    hex_size = File.ReadAllLines(file_name + ".hex").Length;
                    _file_hex = new FileStream(file_name + ".hex", FileMode.Open);
                }
                    
                StreamWriter sw_16bit = new StreamWriter(file_16bit);
                StreamReader sr_hex = new StreamReader(_file_hex);
                file_16bit.Seek(0, SeekOrigin.Begin);
                _file_hex.Seek(0, SeekOrigin.Begin);

                for (int i = 0; i <= 2; i++) sw_16bit.WriteLine(sr_hex.ReadLine());
                sr_hex.ReadLine();
                sw_16bit.WriteLine("10");

                for (int i = 4; i <= hex_size - 1; i++)
                {
                    str = sr_hex.ReadLine();
                    sw_16bit.WriteLine(str.Substring(0, str.Length - 2));
                }

                sw_16bit.Write("0000"); // for avoid empty string in the end of file
                Console.WriteLine("Create 16 bit hex\n");

                sw_16bit.Close();
                //sr_hex.Close();
                _file_hex.Close();
                file_16bit.Close();
            }

            Console.WriteLine("Write hex file complete");

            Console.WriteLine("Create other hex file? (y/n)");
repeat:     ans = Console.ReadLine();
            if (ans == "y") goto new_hex;
            else if (ans == "n")
            {
                Console.WriteLine("press any key...");
                Console.ReadKey();
            }
            else goto repeat;
        }
    }
}