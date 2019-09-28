clear; close all;

[d_1,       f_1] =      getDataHex('orang.hex');
[d_1_16,	f_16_1] =	getDataHex('orang_16bit.hex');

[d_1_cut] =     filCut(d_1, 3);
[d_1_16_cut] =	filCut(d_1_16, 3);

figure;
plot(d_1); hold on;
plot(d_1_16*max(d_1)/max(d_1_16)); grid on;
legend('24', '16');
title('Compare norm imp:');

figure;
plot(d_1_cut); hold on;
plot(d_1_16_cut*max(d_1_cut)/max(d_1_16_cut)); grid on;
legend('24', '16');
title('Compare cut imp:');

[d_2,       f_2] =      getDataHex('c1000.hex');
[d_2_16,	f_2_16] =	getDataHex('c1000_16bit.hex');

[d_2_cut] =     filCut(d_2, 5);
[d_2_16_cut] =	filCut(d_2_16, 5);

figure;
plot(d_2); hold on;
plot(d_2_16*max(d_2)/max(d_2_16)); grid on;
legend('24', '16');
title('Compare norm imp:');

figure;
plot(d_2_cut); hold on;
plot(d_2_16_cut*max(d_2_cut)/max(d_2_16_cut)); grid on;
legend('24', '16');
title('Compare cut imp:');