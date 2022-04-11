%
% Copy this code into Matlab R2014b or up,
% and see the 3d atlas in a Matlab Figure.
% 
% Script generated by the Scalable Brain Atlas (SBA):
% https://scalablebrainatlas.incf.org/services/view3d_l2v.php, with parameters:
% {
%     "template": "PLCJB14",
%     "space": "PLCJB14",
%     "mesh": "wholebrain",
%     "deform": "fiducial",
%     "l2v": "",
%     "clim": "[null,null]",
%     "bg": "[0,0,0]",
%     "width": "800",
%     "height": "800",
%     "cam": "L",
%     "overlay": "labels",
%     "format": "mfile"
% }
%
% Template data is not 'owned' by SBA, read more about licensing 
% and our citation policy at:
% https://scalablebrainatlas.incf.org/main/citationpolicy.php
%

options = weboptions('ContentReader', @importdata);
vertices = webread('https://scalablebrainatlas.incf.org//templates/PLCJB14/meshes/wholebrain_vertices.csv',options);

faces = webread('https://scalablebrainatlas.incf.org//templates/PLCJB14/meshes/wholebrain_faces.csv',options);
faces = round(faces) + 1; % Matlab design flaw: arrays have offset one

vtx2id = webread('https://scalablebrainatlas.incf.org//templates/PLCJB14/meshdata/wholebrain_labels.csv',options);
vtx2id = round(vtx2id) + 1; % Matlab design flaw: arrays have offset one

id2rgb_1 = webread('https://scalablebrainatlas.incf.org//templates/PLCJB14/meshdata/wholebrain_colormap.csv',options);
id2rgb_H = reshape(sprintf('%02X',round(id2rgb_1*255).'),6,[]).'; % convert to hex

% remove unused colors
numColors = size(id2rgb_1,1);
id2used = zeros(1,numColors);
id2used(vtx2id) = 1;
usedColors = find(id2used);
id2used(usedColors) = 1:numel(usedColors);
vtx2id = id2used(vtx2id)';

rgb2acr = webread('https://scalablebrainatlas.incf.org//templates/PLCJB14/template/rgb2acr.json');

% map color index to brain region acronym
id2acr = {};
for i=usedColors
  rgb_H = id2rgb_H(i,:);
  try
    acr = getfield(rgb2acr,rgb_H);
  catch
    acr = getfield(rgb2acr,['x' rgb_H]); % Matlab design flaw: struct fields cannot start with number
  end
  id2acr{i} = acr;
end

clf;
p = patch('Vertices',vertices,'Faces',faces,'FaceVertexCData',vtx2id,...
          'FaceColor','flat','FaceLighting','phong','EdgeColor','none','CDataMapping','scaled');
get(gca,'clim')
set(gcf,'renderer','zbuffer');
lighting('flat');
material('metal');

daspect([1 1 1]);
axis off image

camlight(-40,40);
camlight(-40,40);

colormap(id2rgb_1(usedColors,:));
hBar=colorbar;
nColors = numel(usedColors)
set(hBar,'ytick',1.5:(nColors-1)/nColors:nColors+0.5);
set(hBar,'yticklabel',id2acr(usedColors));