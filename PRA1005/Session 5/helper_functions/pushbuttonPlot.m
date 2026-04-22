function pushbuttonPlot

%set(gcf,'units','pixels')
%A=get(gcf,'position');
button_size=90;%(abs((A(3)-A(1)))/14) %if button_size>100; button_size=100; end
button_gap=10;%(abs((A(3)-A(1)))/100)  %if button_gap>10; button_gap=10; end

%120

c = uicontrol;
c.String = 'Time Zoom In';
c.FontWeight ='bold';
c.Position =[button_gap    20   button_size    31];
c.BackgroundColor=[0.9400 0.9400 0.9400];
c.Callback = @ZoomButtonPushed;

c = uicontrol;
c.String = 'Time Zoom Out';
c.FontWeight ='bold';
c.Position =[(button_gap*2)+(button_size*1)    20   button_size    31];
c.Callback = @ZoomOutButtonPushed;

c = uicontrol;
c.String = 'Y Zoom In';
c.FontWeight ='bold';
c.Position =[(button_gap*3)+(button_size*2)    20   button_size    31];
c.Callback = @YZoomButtonPushed;

c = uicontrol;
c.String = 'Y Zoom Out';
c.FontWeight ='bold';
c.Position =[(button_gap*4)+(button_size*3)    20   button_size    31];
c.Callback = @YZoomOutButtonPushed;

c = uicontrol;
c.String = 'Sound start/stop';
c.FontWeight ='bold';
c.BackgroundColor=[1 0.4 1];
c.Position =[(button_gap*5)+(button_size*4)    20   button_size    31];
c.Callback = @Play_sound;

c = uicontrol;
c.String = 'Sound pointer';
c.FontWeight ='bold';
c.BackgroundColor=[1 0.4 1];
c.Position =[(button_gap*6)+(button_size*5)    20   button_size    31];
c.Callback = @Play_point;

c = uicontrol;
c.String = 'Scope View';
c.FontWeight ='bold';
c.Position =[(button_gap*7)+(button_size*6)    20   button_size    31];
c.BackgroundColor=[0.8400 0.8400 1];
c.Callback = @ScopeView;

c = uicontrol;
c.String = 'Spike threshold';
c.FontWeight ='bold';
c.Position =[(button_gap*8)+(button_size*7)    20   button_size    31];
c.BackgroundColor=[0.7400 1 0.7400];
c.Callback = @Spike_threshold;

c = uicontrol;
c.String = 'Noise threshold';
c.FontWeight ='bold';
c.Position =[(button_gap*9)+(button_size*8)    20   button_size    31];
c.BackgroundColor=[1 0.8400 0.8400];
c.Callback = @noise_threshold;

c = uicontrol;
c.String = 'Cut data';
c.FontWeight ='bold';
c.Position =[(button_gap*10)+(button_size*9)    20   button_size    31];
c.BackgroundColor=[0.6400 0.6400 1];
c.Callback = @Cut_data;

c = uicontrol;
c.String = 'Finalize';
c.FontWeight ='bold';
c.Position =[(button_gap*11)+(button_size*10)    20   button_size    31];
c.BackgroundColor=[1 1 0.500];
c.Callback = @Finalize;

c = uicontrol;
c.String = 'Skip';
c.FontWeight ='bold';
c.BackgroundColor=[0.44 1 0.4400];
c.Position =[(button_gap*12)+(button_size*11)    20   button_size    31];
c.Callback = @Skip;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Skip(src,event)
        global go_on
        go_on=1;
    end

    function Finalize(src,event)
        global go_on
        go_on=1;
    end

    function ZoomButtonPushed(src,event)
        [zoom_time,y] = ginput(1);
        set(gca,'xlim',[zoom_time-.5 zoom_time+.5] )
        drawnow
    end

    function ZoomOutButtonPushed(src,event)
        H=get(gca);
        set(gca,'xlim',[min(H.Children(end).XData) max(H.Children(end).XData)] )
        drawnow
    end

    function YZoomButtonPushed(src,event)
        [y,zoom_Y] = ginput(2);
        set(gca,'ylim',[min(zoom_Y) max(zoom_Y)] )
        drawnow
    end

    function YZoomOutButtonPushed(src,event)
        H=get(gca);
        set(gca,'ylim',[min(H.Children(end).YData) max(H.Children(1).YData)] )
        drawnow
    end

    function Spike_threshold(src,event)
        H=get(gca);
        for J=1:size(H.Children,1)
            if sum(H.Children(J).Color==[0 1 0])==3
                delete(H.Children(J))
            end
        end

        H=get(gca);
        [x,thrmin] = ginput(1);
        plot([min(H.Children(end).XData) max(H.Children(end).XData)],[thrmin thrmin],'g-'); hold on;
        drawnow
    end

    function noise_threshold(src,event)
        H=get(gca);
        for J=1:size(H.Children,1)
            if sum(H.Children(J).Color==[1 0 0])==3
                delete(H.Children(J))
            end
        end

        H=get(gca);
        [x,thrmax] = ginput(1);
        plot([min(H.Children(end).XData) max(H.Children(end).XData)],[thrmax thrmax],'r-'); hold on;
        drawnow
    end

    function Cut_data(src,event)
        H=get(gca);
        for J=1:size(H.Children,1)
            if sum(H.Children(J).Color==[0 0 1])==3
                delete(H.Children(J))
            end
        end
        H=get(gca);
        for J=1:size(H.Children,1)
            if sum(H.Children(J).Color==[0 0 .95])==3
                delete(H.Children(J))
            end
        end

        [cutX,Y] = ginput(2);
        plot([min(cutX) min(cutX)],[min(H.Children(end).YData) max(H.Children(end).YData)],'color',[0 0 1] ); hold on
        plot([max(cutX) max(cutX)],[min(H.Children(end).YData) max(H.Children(end).YData)],'color',[0 0 .95] ); hold on
        set(gca,'xlim',[min(cutX)-.5 max(cutX)+.5 ])
        drawnow
    end

    function Play_sound(src,event)
        global play_sound;
        if play_sound==0
            play_sound=1;
        else
            play_sound=-1;
        end
    end

    function ScopeView(src,event)
        global play_sound;
        if play_sound~=4
            play_sound=4;
        else
            play_sound=-1;
        end
    end

    function Play_point(src,event)
        H=get(gca);
        H=get(gca);
        [soundx,~] = ginput(1);
        plot([min(soundx) min(soundx)],[min(H.Children(end).YData) max(H.Children(end).YData)],'m-','linewidth',0.5); hold on;
        drawnow
        global play_sound;
        play_sound=3
    end
end


