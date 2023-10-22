function array=boundary_detection_array(check)

if check==1
    dy=0.2;
    dx=0.2;
    y_0=-3.8-dx;
    x_0=1.32139022764325-dx;
    for x=1:15
        for y=1:32+15
            array(x,y,1)=10^(dx*x+x_0);
            array(x,y,2)=10^(dy*y+y_0);
            array(x,y,3)=array(x,y,1)*array(x,y,2);
            if array(x,y,3) < 3.3218 || array(x,y,3) > 3.322e6
                array(x,y,:)=0;
            end
        end
    end
end
    