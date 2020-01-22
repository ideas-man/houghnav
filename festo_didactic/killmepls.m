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
init_x = [];
init_y = [];
ready_flag = 1;
tElapsed_compare = 0;

while (Bumper_value(BumperId) ~= 1)
    
    tElapsed = toc;
    
    if(tElapsed > 20 )
        break;
    end;
    
    if ~(Camera_setStreaming(CameraId, 1) == 1)
        disp('Camera_setStreaming failed.');
    end; 
    
    if (ready_flag==0)
        img = (imread('sh_corr_mov_03.jpg'));
        [init_x, init_y] = hough_nav(img);
        if (init_x <160)
             OmniDrive_setVelocity(OmniDriveId, 0, 0 ,100);
             pause (5);
             ready_flag=1;
        end;
        if (init_x>160)
            OmniDrive_setVelocity(OmniDriveId, 0, 0 ,-100);
             pause (5);
             ready_flag=1;
        end;
    end;
    if (ready_flag==1)
        img = (imread('sh_corr_mov_03_.jpg'));
        [init_x, init_y] = hough_nav(img)
        if (init_x <160)
             OmniDrive_setVelocity(OmniDriveId, 0, 0 ,100);
             pause (5);
             ready_flag=0;
        end;
        if (init_x>160)
            OmniDrive_setVelocity(OmniDriveId, 0, 0 ,-100);
             pause (5);
             ready_flag=0;
        end;
    end;
    
    
end;
Com_disconnect(ComId);

Camera_destroy(CameraId);
Bumper_destroy(BumperId);
OmniDrive_destroy(OmniDriveId);
Com_destroy(ComId);