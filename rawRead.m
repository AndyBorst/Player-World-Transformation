lightX = 0;
lightY = 0;
lightZ = -5;
camera = [0,0,-10];
cameraDir = [0,0,0];
objPos = [0,0,0];
objOr = deg2rad([0,90,0]);
fov = 90;
nearDis = 1;
farDis = 100;
M_diff = [1,.5,.7];

function [worldCoor] = worldM(objPos,objOr)
fin=fopen('shark_ag.raw', 'r');
data = fscanf(fin, "%f");
fclose(fin)
model = reshape(data,[3,numel(data)/3]);
model = model';
model = [model, ones(size(model,1),1)];
matTrans = [1, 0, 0, 0,
             0, 1, 0, 0,
             0, 0, 1, 0,
              objPos(1), objPos(2), objPos(3), 1];
matRotX = [1, 0, 0, 0,
            0, cos(objOr(1)), sin(objOr(1)), 0,
            0, -sin(objOr(1)), cos(objOr(1)), 0,
            0, 0, 0, 1];
matRotY = [cos(objOr(2)), 0, -sin(objOr(2)), 0,
            0, 1, 0, 0,
            sin(objOr(2)), 0, cos(objOr(2)), 0,
            0, 0, 0, 1];
matRotZ = [cos(objOr(3)), sin(objOr(3)), 0, 0,
            -sin(objOr(3)), cos(objOr(3)), 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1];
rot = matRotX * matRotY * matRotZ
worldCoor = model * matRotX * matRotY * matRotZ * matTrans;

end

function [worldCoor, worldCoorAdd] = letThereBeLight(lightX, lightY, lightZ, worldCoor, M_diff)
lightMat = [];
worldCoorAdd = [];
for index = 1:3:size(worldCoor,1)
    x = [worldCoor(index,1),worldCoor(index,2),worldCoor(index,3)];
    y = [worldCoor(index+1,1),worldCoor(index+1,2),worldCoor(index+1,3)];
    z = [worldCoor(index+2,1),worldCoor(index+2,2),worldCoor(index+2,3)];
    lighting = cross(y - x, z - x);
    mag = norm(lighting);
    normalLighting = lighting/mag;
    lightMat = [lightMat, normalLighting];
    center = [(x+y+z)/3];
    lightVec = [lightX - center(1), lightY - center(2), lightZ - center(3)];
    normalLight = lightVec/(norm(lightVec));
    cDif = M_diff * max(dot(normalLighting, normalLight), 0);
    worldCoorAdd  = [worldCoorAdd; cDif; cDif; cDif];
end
%worldCoor  = [worldCoor, worldCoorAdd];
end

function [newVec] = viewTransform(camera, cameraDir, worldCoor)
zaxis = (cameraDir - camera)/norm(cameraDir - camera);
upDir = [0,1,0]
xAxisCross = cross(upDir, zaxis)
xaxis = xAxisCross/(norm(xAxisCross));
yaxis = cross(zaxis, xaxis);

newVec = [
 xaxis(1),           yaxis(1),           zaxis(1),          0,
 xaxis(2),           yaxis(2),          zaxis(2),          0,
 xaxis(3),           yaxis(3),           zaxis(3),          0,
-dot(xaxis, camera),  -dot(yaxis, camera),  -dot(zaxis, camera),  1 ]
newVec = worldCoor * newVec 
end

function [newVec] = orthoProj(nearDis, farDis, fov, worldCoord)
yScale = cot(deg2rad(fov)/2)
xScale = yScale/1
newVec = [xScale,     0,          0,               0,
0,       yScale,       0,              0,
0,          0,       farDis/(farDis-nearDis),         1,
0 ,         0,       -nearDis*farDis/(farDis-nearDis),     0];
newVec = worldCoord * newVec
end

function [model] = perspecDiv(a)
model = a;
for index = 1:size(model,1);
    model(index,1) = model(index,1)/model(index,4);
    model(index,2) = model(index,2)/model(index,4);
    model(index,3) = model(index,3)/model(index,4);
end
end

function [model, indices] = zCull(b)
model = b;
newModel = []
indices = [];
for index = 1:3:size(model,1);
    if (model(index, 3) >= 0) && (model(index + 1, 3) >= 0) && (model(index+2, 3) >= 0) && (model(index, 3) <= 1) && (model(index + 1, 3) <= 1) && (model(index+2, 3) <= 1) 
        newModel = [newModel; model(index, :); model(index + 1,:); model(index + 2,:)];
        indices = [indices; index; (index + 1); (index +2)];
    end
end
model = newModel
end

function [finalModel] = sortingEnd(c, worldCoorAdd, indices)
%worldCoorAdd = worldCoorAdd(indices)
c  = [c, worldCoorAdd];
model = c;
emptyVec = [];
[r,c] = size(model)
finalModel = zeros(r,c);
for index = 1:3:size(model,1);
    zValues = (model(index,3) + model(index + 1, 3) + model(index + 2, 3))/3;
         emptyVec= [emptyVec; zValues];
end
[B, I] = sort(emptyVec, "descend")
for index = 1:size(I)
    num = I(index,1)
    finalModel((index*3) - 2, :) = model((num*3) - 2, :);
    finalModel((index*3) - 1, :) = model((num*3) - 1, :);
    finalModel(index*3, :) = model(num*3, :);
end
u = 1;
end

function [] = rawReads(worldCoor)
model = worldCoor;
for index = 1:3:size(model,1)
    x = [model(index,1),model(index+1,1),model(index+2,1)];
    y = [model(index,2),model(index+1,2),model(index+2,2)];
    z = [model(index,3),model(index+1,3),model(index+2,3)];
    color = [model(index,5),model(index,6),model(index,7)];
    %color = [.3,0,.5]
    set(0,'DefaultPatchEdgeColor','none')
    patch(x,y,color)
end
hold off
end

x = worldM(objPos, objOr)
[y, worldCoorAdd] = letThereBeLight(lightX, lightY, lightZ, x, M_diff)
z = viewTransform(camera, cameraDir, y)
a = orthoProj(nearDis, farDis, fov, z)
b = perspecDiv(a)
[c, indices] = zCull(b)
d = sortingEnd(c, worldCoorAdd, indices)
rawReads(d)
