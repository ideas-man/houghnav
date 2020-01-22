ComId = Com_construct;

%OmniDriveId = OmniDrive_construct;
CameraId = Camera_construct;
BumperId = Bumper_construct;

Com_setAddress(ComId, '127.0.0.1:8080');
Com_connect(ComId);

while (Bumper_value(BumperId) ~= 1)
tStart = tic;
tElapsed = toc(tStart)
while(tElapsed <=60)
img = Camera_getImage( CameraId );
        threshold = 50;
        image(img); title('An image from the camera onboard Robotino')
     
end;
break;
end;
Com_disconnect(ComId);

Camera_destroy(CameraId);
Bumper_destroy(BumperId);
%OmniDrive_destroy(OmniDriveId);
Com_destroy(ComId);