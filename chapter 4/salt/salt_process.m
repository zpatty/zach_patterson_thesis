
clear
close all
opts = detectImportOptions('salt_tensile.is_tcyclic_RawData/Specimen_RawData_1.csv');
names = {'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11'};
for i =2:4
    filename = strcat('salt_tensile.is_tcyclic_RawData/Specimen_RawData_', num2str(i), '.csv');
    s.(names{i}) = readtable(filename, opts);
    dat = s.(names{i});
    force = dat.Load;
    plot(dat.Extension, dat.Load)
    hold on
end
legend('Freshwater', 'Saltwater 1', 'Saltwater 2')
xlabel('Extension (mm)')
ylabel('Load (N)')