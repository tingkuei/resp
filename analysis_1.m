clear;
clc;
[X(:,1),X(:,2),time1]=textread('201501211809_download.txt','%f%f%s','headerlines',0);
[D(:,1),D(:,2),time2]=textread('20150121180932_parse.txt','%f%f%s','headerlines',0);

start_time1=str2double(time1{1}(1:2))*60*60+str2double(time1{1}(4:5))*60+str2double(time1{1}(7:8));
start_time2=str2double(time2{1}(1:2))*60*60+str2double(time2{1}(4:5))*60+str2double(time2{1}(7:8));
finish_time1=str2double(time1{size(time1,1)}(1:2))*60*60+str2double(time1{size(time1,1)}(4:5))*60+str2double(time1{size(time1,1)}(7:8));
finish_time2=str2double(time2{size(time2,1)}(1:2))*60*60+str2double(time2{size(time2,1)}(4:5))*60+str2double(time2{size(time2,1)}(7:8));
% start time alligenmnet
if start_time1 > start_time2
    id=1;
    for i=1:size(D,1)
        temp_time=str2double(time2{i}(1:2))*60*60+str2double(time2{i}(4:5))*60+str2double(time2{i}(7:8));
        if temp_time >= start_time1
            Temp(id,:)=D(i,:);
            Temp_time(:,id) = time2(i);
            id=id+1;
        end
    end
    D=Temp;
    time2=Temp_time;
else
    id=1;
    for i=1:size(X,1)
        temp_time=str2double(time1{i}(1:2))*60*60+str2double(time1{i}(4:5))*60+str2double(time1{i}(7:8));
        if temp_time >= start_time2
            Temp(id,:)=X(i,:);
            Temp_time(id,:) = time1(i);
            id=id+1;
        end
    end
    X=Temp;
    time1=Temp_time;
end
clear Temp Temp_time;
% finish time alligenmnet
if finish_time1 > finish_time2
    id=1;
    for i=1:size(X,1)
        temp_time=str2double(time1{i}(1:2))*60*60+str2double(time1{i}(4:5))*60+str2double(time1{i}(7:8));
        if temp_time <= finish_time2
            Temp(id,:)=X(i,:);
            Temp_time(id,:) = time1(i);
            id=id+1;
        end
    end   
    X=Temp;
    time1=Temp_time;
else
    id=1;
    for i=1:size(D,1)
        temp_time=str2double(time2{i}(1:2))*60*60+str2double(time2{i}(4:5))*60+str2double(time2{i}(7:8));
        if temp_time <= finish_time1
            Temp(id,:)=D(i,:);
            Temp_time(:,id) = time2(i);
            id=id+1;
        end
    end
    D=Temp;
    time2=Temp_time;
end                
start_time=str2double(time1{1}(1:2))*60*60+str2double(time1{1}(4:5))*60+str2double(time1{1}(7:8));
finish_time=str2double(time1{size(time1,1)}(1:2))*60*60+str2double(time1{size(time1,1)}(4:5))*60+str2double(time1{size(time1,1)}(7:8));
seconds=finish_time-start_time;
% moving average 
window_size=3;
window_time=start_time;
Avg=[];
for j=1:seconds-window_size+1
    k=1;
    temp_sum=0;
    temp_avg=0;
    num=0;
    while(true)
      if str2double(time1{k}(1:2))*60*60+str2double(time1{k}(4:5))*60+str2double(time1{k}(7:8)) >= window_time+window_size 
          Avg=[Avg temp_sum/num];
          temp_sum=0;
          num=0;
          break;
      elseif str2double(time1{k}(1:2))*60*60+str2double(time1{k}(4:5))*60+str2double(time1{k}(7:8)) >= window_time
         temp_sum=temp_sum+X(k,1);
         k=k+1;
         num=num+1;
      else
         k=k+1;
      end    
    end
    window_time=window_time+1;
end
%label genearation    
Y=[];
for j=2:size(Avg,2)
    if Avg(j)>Avg(j-1)
        Y(j-1)=+1;
    else    
        Y(j-1)=-1;
    end    
end   
%RSCP ECIO
Avg_Ecio=[];
Std_Ecio=[];
Max_Ecio=[];
Min_Ecio=[];
Q1_Ecio=[];
Q3_Ecio=[];
Avg_Rscp=[];
Std_Rscp=[];
Max_Rscp=[];
Min_Rscp=[];
Q1_Rscp=[];
Q3_Rscp=[];
temp_value1=[];
temp_value2=[];
window_time=start_time;
for j=1:seconds-window_size+1
    k=1;
    temp_value1=[];
    temp_value2=[];
    while(true)
      if str2double(time2{k}(1:2))*60*60+str2double(time2{k}(4:5))*60+str2double(time2{k}(7:8)) >= window_time+window_size 
          if size(temp_value1,2) ~= 0
            Q1_Ecio=[Q1_Ecio prctile(temp_value1,25)];
            Q3_Ecio=[Q3_Ecio prctile(temp_value1,75)];
            Avg_Ecio=[Avg_Ecio mean(temp_value1)];
            Std_Ecio=[Std_Ecio std(temp_value1)];
            Max_Ecio=[Max_Ecio max(temp_value1)];
            Min_Ecio=[Min_Ecio min(temp_value1)];
          else
            Q1_Ecio=[Q1_Ecio Q1_Ecio(size(Q1_Ecio,1))];  
            Q3_Ecio=[Q3_Ecio Q3_Ecio(size(Q3_Ecio,1))];   
            Avg_Ecio=[Avg_Ecio Avg_Ecio(size(Avg_Ecio,1))];  
            Std_Ecio=[Std_Ecio Std_Ecio(size(Std_Ecio,1))];
            Max_Ecio=[Max_Ecio Max_Ecio(size(Max_Ecio,1))];
            Min_Ecio=[Min_Ecio Min_Ecio(size(Min_Ecio,1))];
          end
          if size(temp_value2,2) ~= 0
            Q1_Rscp=[Q1_Rscp prctile(temp_value2,25)];
            Q3_Rscp=[Q3_Rscp prctile(temp_value2,75)];
            Avg_Rscp=[Avg_Rscp mean(temp_value2)];  
            Std_Rscp=[Std_Rscp std(temp_value2)];
            Max_Rscp=[Max_Rscp max(temp_value2)];
            Min_Rscp=[Min_Rscp min(temp_value2)];
          else
            Q1_Rscp=[Q1_Rscp Q1_Rscp(size(Q1_Rscp,1))];  
            Q3_Rscp=[Q3_Rscp Q3_Rscp(size(Q3_Rscp,1))];
            Avg_Rscp=[Avg_Rscp Avg_Rscp(size(Avg_Rscp,1))];  
            Std_Rscp=[Std_Rscp Std_Rscp(size(Std_Rscp,1))];
            Max_Rscp=[Max_Rscp Max_Rscp(size(Max_Rscp,1))];
            Min_Rscp=[Min_Rscp Min_Rscp(size(Min_Rscp,1))];
          end
          break;
      elseif str2double(time2{k}(1:2))*60*60+str2double(time2{k}(4:5))*60+str2double(time2{k}(7:8)) >= window_time
         temp_value1=[temp_value1 D(k,1)];
         temp_value2=[temp_value2 D(k,2)];
         k=k+1;
      else
         k=k+1;
      end    
    end
    window_time=window_time+1;
end
Data(1,:)=Avg(1,2:size(Avg,2));
Data(2,:)=Max_Ecio(1,2:size(Max_Ecio,2));
Data(3,:)=Min_Ecio(1,2:size(Min_Ecio,2));
Data(4,:)=Std_Ecio(1,2:size(Std_Ecio,2));
Data(5,:)=Max_Rscp(1,2:size(Max_Rscp,2));
Data(6,:)=Min_Rscp(1,2:size(Min_Rscp,2));
Data(7,:)=Std_Rscp(1,2:size(Std_Rscp,2));
Data=Data';        

figure(1);
subplot(3,1,1);
k=plot(Avg,'o-');
set(k, 'MarkerSize', 10, 'MarkerFaceColor', 'b', ...
    'MarkerEdgeColor', [0 .5 0]);
axis([0,size(Avg,2),-inf,inf]);
ylabel('Avg Data rate');
subplot(3,1,2);
h=errorbar(1:size(Avg_Ecio,2),Avg_Ecio,Avg_Ecio-Q1_Ecio,Q3_Ecio-Avg_Ecio,'o-');
set(h, 'MarkerSize', 10, 'MarkerFaceColor', [.3 1 .3], ...
    'MarkerEdgeColor', [0 .5 0]);
axis([0,size(Avg_Ecio,2),-inf,inf]);
ylabel('Ecio');
subplot(3,1,3);
g=errorbar(1:size(Avg_Rscp,2),Avg_Rscp,Avg_Rscp-Q1_Rscp,Q3_Rscp-Avg_Rscp,'o-');
set(g, 'MarkerSize', 10, 'MarkerFaceColor', 'r', ...
    'MarkerEdgeColor', [0 .5 0]);
axis([0,size(Avg_Rscp,2),-inf,inf]);
ylabel('Avg Rscp');

figure(2);
subplot(3,1,1);
plot(Avg,'b');
axis([0,size(Avg,2),-inf,inf]);
ylabel('Avg Data rate');
subplot(3,1,2);
plot(Std_Ecio,'g');
axis([0,size(Std_Ecio,2),-inf,inf]);
ylabel('Ecio');
subplot(3,1,3);
plot(Avg_Rscp,'r')
axis([0,size(Avg_Rscp,2),-inf,inf]);
ylabel('Avg Rscp');