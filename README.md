# Комментарии #

### Порядок действий для запуска ###

* Сгенерировать поворачивающие коэффициенты нужного размера и количества в Excel
* Скопировать действительную и мниную части в файлы 'w_re_1.txt' и 'w_im_1.txt' соответственно
* Сгенерировать MIF для ROM FPGA с помощью 'get_mif.m', размер указывается как  количество точек БПФ, делённое на 4


### Замечания ###

* Чтобы нормализовать значения после умножителей - требуется делить результат на максимальное значение поворачивающего
 множителя, поэтому чтобы заменить деление сдвигом выбирается битность множителей на 1 бит больше, таким образом,
 например 12 битные коэффициенты будут принимать значения +/- 1024, а не 2047, это надо учитывать при их генерации в
 Excel и брать значение битности с запасом
