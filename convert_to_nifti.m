clc; clear; close all;

% Define paths
dataRoot = 'C:\Users\Aparajeeta - Cedars-Sinai Health System\Data\';
outputRoot = fullfile(dataRoot, 'nnUNet_prepared_data');
imagesTr = fullfile(outputRoot, 'imagesTr');
labelsTr = fullfile(outputRoot, 'labelsTr');
if ~exist(imagesTr, 'dir'); mkdir(imagesTr); end
if ~exist(labelsTr, 'dir'); mkdir(labelsTr); end

% Get subjects
subjects = dir(fullfile(dataRoot, 'SUBJECT_*'));
subjects = subjects([subjects.isdir]);
fprintf('Found %d subjects\n', numel(subjects));

for s = 1:numel(subjects)
    subjName = subjects(s).name;
    subjPath = fullfile(dataRoot, subjName);
    matFiles = dir(fullfile(subjPath, '*T2star_map.mat'));
    if isempty(matFiles)
        warning('No .mat file in %s', subjName);
        continue;
    end
    [~, idx] = max([matFiles.datenum]);
    matFile = fullfile(subjPath, matFiles(idx).name);
    data = load(matFile);

    if ~isfield(data, 'Mag_all') || ~isfield(data, 'Mask_myo')
        warning('Missing Mag_all or Mask_myo in %s', subjName);
        continue;
    end

    Mag_all = data.Mag_all;
    Mask_myo = data.Mask_myo;

    if isfield(data, 't2Map_all')
        T2_all = data.t2Map_all;
    else
        warning('t2Map_all missing in %s', subjName);
        T2_all = [];
    end

    numSlices = size(Mag_all, 3);
    numPhases = size(Mag_all, 4);

    for ph = 1:numPhases
        vol1 = squeeze(Mag_all(:,:,:,ph));
        mask = squeeze(Mask_myo(:,:,:,ph));

        vol1 = double(vol1);
        vol1 = vol1 ./ max(vol1(:));

        if ~isempty(T2_all)
            vol2 = squeeze(T2_all(:,:,:,ph));
            vol2 = double(vol2);
            vol2 = vol2 ./ max(vol2(:));
        end

        caseID = sprintf('subj%03d_phase%02d', s, ph);

        nii_img1 = make_nii(vol1);
        save_nii(nii_img1, fullfile(imagesTr, sprintf('%s_0000.nii', caseID)));
        gzip(fullfile(imagesTr, sprintf('%s_0000.nii', caseID)));
        delete(fullfile(imagesTr, sprintf('%s_0000.nii', caseID)));

        if ~isempty(T2_all)
            nii_img2 = make_nii(vol2);
            save_nii(nii_img2, fullfile(imagesTr, sprintf('%s_0001.nii', caseID)));
            gzip(fullfile(imagesTr, sprintf('%s_0001.nii', caseID)));
            delete(fullfile(imagesTr, sprintf('%s_0001.nii', caseID)));
        end

        nii_mask = make_nii(double(mask));
        save_nii(nii_mask, fullfile(labelsTr, sprintf('%s.nii', caseID)));
        gzip(fullfile(labelsTr, sprintf('%s.nii', caseID)));
        delete(fullfile(labelsTr, sprintf('%s.nii', caseID)));
    end
end

fprintf('Conversion complete. NIfTI files saved in:\n%s\n', outputRoot);
