% DESCRIPTION:
%   This code finds the length of days where a temperature exists within a 
%   certain threshold and then shows how this length of days has varied over time when compared
%   to a baseline.  
%
% AUTHORS:Kasey Cannon
%
% REFERENCE:
%    Written for EESC 4464: Environmental Data Exploration and Analysis, Boston College
%    Data are from the  
%==================================================================
%% Load in the Data and assign relevant variables 
Seatac='2114119.csv';
stationdata = readtable(Seatac);
date = stationdata.DATE;
precip = stationdata.PRCP;
temp = stationdata.TMAX;

% Adjustment to date year so Matlab can read the dates correctly 
[y,m,d] = ymd(date);

for i=1:length(y)
if y(i)<20
    y(i) = y(i)+2000;
    
else 
    y(i) = y(i)+1900;
end 
end

date = datenum([y,m,d]);
%% 

%Preliminary plotting of the downloaded data 

figure(1)
scatter(date,temp,'.')
ylabel('Temperature ^o F')
xlabel('Date')
title('Temperature Highs at Seattle-Tacoma Airport from 1948-2020')
datetick('x','dd-mmm-yyyy')
 
figure(2)
scatter(date,precip,'.')
ylabel('Precipitation Amounts (in)')
xlabel('Date')
title('Precipitation Levels at Seattle-Tacoma Airport from 1948-2020')
datetick('x','dd-mmm-yyyy')


%%
%Process to assign number of summer days per year using true/false
%statements and an assigned temperature threshold of 65 degrees
%Farenheight. If the temperature being read is above 65 degrees for
%ten days in a row the eleventh day would be the first day of summer. 
%The end of summer would be the tenth day of under 65 degree weather in a row. 
years = NaN(71,1);
sumdays=NaN(71,1);

for j=1:71
    
    year = j +1947;
    
    I = find(y==year);
    tempyear = temp(I); 

summer = false; 
summer_days = 0;
counter = 0; 
debug_counter = 0;

    for i = 1:365 
    
        if summer == false
        
        if  tempyear(i) >= 65 
            counter = counter +1;
        else 
            counter = 0;
        end
         
        if counter == 10 
            summer = true; 
            counter = 0; 
            debug_counter = debug_counter + 1;
           
        end
        
        else 
            if tempyear(i) < 65
                counter = counter + 1;
            
            else 
                counter = 0;
            end
        
            summer_days = summer_days+1;
        
            if counter == 10 
                summer = false; 
                counter = 0; 
                debug_counter = debug_counter + 1;
                
            end


        end
       
    end

  sumdays(j) = summer_days;
  years(j)= year;
  if debug_counter ~= 2
      
  end
end


%%
%Plot of length of summer days per year through the time period of the data
figure(3)

plot(years,sumdays,'k.:','LineWidth',1.5)
hold on
xlabel('Year')
ylabel('Length of Summer (days)')
title('Length of Summer Days in Northwest Region')


%% 
% A baseline was created to compare the length of years to a baseline mean
% which was assigned to be 1981-2000. The data then had the baseline
% subtracted from it to create difference from the baseline for each year.
% A linear line was then fit to the data to show any longer term linear
% behavior. 
 
 Imean = find(years > 1980 & years < 2001);
 baseline_mean = mean(sumdays(Imean));
 SumDaysMeanAnomaly = sumdays - baseline_mean;
 SumDaysMeanSmooth= movmean(SumDaysMeanAnomaly,5);
 
 P_all = polyfit(years, SumDaysMeanAnomaly, 1);
 
 %In order to compare long term behavior to more recent a liner line was
 %also fit to just the last 20 years. 
 RecentYear = 1980;
 indrecent = find(years == RecentYear);
 P_recent = polyfit(years(indrecent:end), SumDaysMeanAnomaly(indrecent:end), 1);
 
 %The difference, and linear behaviors were then all plotted on the same
 %axis to show and compare behavioral trends.  
 
 figure(4)
 scatter(years,SumDaysMeanAnomaly,'b.')
 hold on 
 plot (years,SumDaysMeanSmooth,'b:','LineWidth',1.5)
 xlabel('Year') 
 xlim([1945 2025])
 ylabel('Days of Summer')
 title('The Length of Summer Days Compared to 1981-2000 Baseline')
 hold on 

 hline =refline(P_all(1,1),P_all(1,2));
 hline.Color = 'g';
 hold on 

 f=polyval(P_recent,years(indrecent:end));
 plot(years(indrecent:end),f,'-c')
 
 legend('Length of Summer Anomaly','Smoothed Summer Anomaly','Linear Trend','Linear Trend from 1980-2020')
 
 

 
 
 
 
 
 