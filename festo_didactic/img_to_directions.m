addpath('E:\Work\Programs\Festo Didactic\RobotinoMatlab\toolbox');

ComId = Com_construct;
OmniDriveId = OmniDrive_construct;
CameraId = Camera_construct;
BumperId = Bumper_construct;

Com_setAddress(ComId, '127.0.0.1:8080');
Com_connect(ComId);

OmniDrive_setComId(OmniDriveId, ComId);
Camera_setComId(CameraId, ComId);
Bumper_setComId(BumperId, ComId);
 
tic;
f = figure;
n_frames = 0;
init_x = 0;
init_y = 0;
ready_flag = 0;
tElapsed_compare = 0;

while (Bumper_value(BumperId) ~= 1)
    
    tElapsed = toc;
    
    if(tElapsed > 10 )
        break;
    end;
    
    if ~(Camera_setStreaming(CameraId, 1) == 1)
        disp('Camera_setStreaming failed.');
    end; 
    
    if (Camera_grab(CameraId) == 1)
        %n_frames = n_frames + 1;
        img = Camera_getImage( CameraId );
        figure(f); imshow(img); title(['Frame: ', num2str(n_frames)]);
        pause(0.01);
            
        [init_x, init_y] = hough_nav(img)
            
    end;   
end;
    
    
    
       

Com_disconnect(ComId);

Camera_destroy(CameraId);
Bumper_destroy(BumperId);
OmniDrive_destroy(OmniDriveId);
Com_destroy(ComId);