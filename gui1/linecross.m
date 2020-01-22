% % %  Пересечение двух прямых

function [x, y] = linecross(xy1,xy2)

A1 = xy1(2) - xy1(4);
B1 = xy1(3) - xy1(1);
C1 = xy1(1) * xy1(4) - xy1(3) * xy1(2);

A2 = xy2(2) - xy2(4);
B2 = xy2(3) - xy2(1);
C2 = xy2(1) * xy2(4) - xy2(3) * xy2(2);

if A1 * B2 == A2 * B1 % если параллельны
    x = xy1(3);
    y = xy1(4);
else 
    x = (B1 * C2 - B2 * C1) / (A1 * B2 - A2 * B1);
    y = (C1 * A2 - C2 * A1) / (A1 * B2 - A2 * B1);
end

