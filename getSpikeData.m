%%%% Author - Aamir Abbasi
%%%% LC Data Analysis
%%%% SCRIPT TO READ CONTINOUS SPIKING DATA FROM TDT BLOCKS AND STORE IT IN A RAW BINARY FILE
%%%% THIS SCRIPT PREPARES THE DATA FOR SPIKE SORTING USING SPYKING CIRCUS
%% -------------------------------------------------------------------------------------------------------------------------------
clc; clear; close;
disp('running...');
root = 'Z:\Riera Lab\LC Recordings\PD_342\'; % Modify the root and savepath based on the location of your data
savepath = 'Z:\Riera Lab\LC Recordings\PD_342\';
cd(root);
blocks = {'PD_342-200924-*'}; % Here the name of folders where you have recorded the data from a single animal will be defined
chans = [2]; % You can add more channels to this vector by doing something like this [1,2,...]
tic;
for j=1:length(blocks)
  blockNames = dir(blocks{j});
  parfor i = 1:length(blockNames)
    blockpath = [root,blockNames(i).name,'\'];
    disp(blockpath);
    for ch = 1:length(chans)
      % Read data from SingleUnits1 gizmo
      raw = TDTbin2mat(blockpath,'STORE','SU_1','CHANNEL',chans(ch));
      
      % Extract spike data
      su = raw.streams.SU_1.data;
      
      % Check if savepath exists, if not then make it.
      currentpath = [savepath,blockNames(i).name(1:13),'_DAT_files\Channel_',num2str(chans(ch)),'\'];
      if ~exist(currentpath, 'dir')
        mkdir(currentpath);
      end
      
      % Save spike data to a binary file
      su = su(:)';
      fileID = fopen([currentpath,'spikes_',num2str(i-1),'.dat'],'w');
      fwrite(fileID,su,'float32');
      fclose(fileID);
    end
  end
end
runTime = toc;
disp(['done! time elapsed (hours) - ', num2str(runTime/3600)]);
