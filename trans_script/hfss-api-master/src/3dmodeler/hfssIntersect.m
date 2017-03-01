% ----------------------------------------------------------------------------
% This file is part of HFSS-MATLAB-API.
%
% HFSS-MATLAB-API is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the Free 
% Software Foundation; either version 2 of the License, or (at your option) 
% any later version.
%
% HFSS-MATLAB-API is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
% or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License 
% for more details.
%
% You should have received a copy of the GNU General Public License along with
% Foobar; if not, write to the Free Software Foundation, Inc., 59 Temple 
% Place, Suite 330, Boston, MA  02111-1307  USA
%
% Copyright 2004, Vijay Ramasami (rvc@ku.edu)
% ----------------------------------------------------------------------------
function hfssIntersect(fid, IntersectArray, Clone)
	% Creates the necessary VB script to subtract a set of tool parts from a set 
	% of blank parts, a.k.a., will produce blank parts - tool parts.
	% hfssSubtract will result in blankParts - toolParts.
	%
	% Parameters :
	% fid:			file identifier of the HFSS script file.
	% blankParts:	a cell array of strings that contain the blank parts.
	% toolParts:	a cell array of strings that contain the tool parts.
	% Clone:		(optional) Boolean variable - If true, then clones toolParts 
	%				after subtraction. Default value is 'false'.
	%
	% Example :
	% @code
	% fid = fopen('myantenna.vbs', 'wt');
	% ... 
	% hfssSubtract(fid, {'BigPlate'}, {'SmallPlate'});
	% @endcode
	%
	% @author Daniel Rodriguez Prado, danysan@gmail.com / drprado@tsc.uniovi.es
	% @date 07 August 2014

	% ----------------------------------------------------------------------------
	% CHANGELOG
	%
	% ??-????-2014: *Initial release (VR).
	% 07-Augu-2014: *Added option to clone parts (DRP).
	% ----------------------------------------------------------------------------

	if (nargin < 4)
	    Clone = [];
	end

	if isempty(Clone)
	    Clone = 'false';
	end

	% Preamble.
	fprintf(fid, '\n');
	fprintf(fid, 'oEditor.Intersect _\n');
	fprintf(fid, 'Array("NAME:Selections", "Selections:=",  _\n');
	if (iscell(toolParts))
		nTool = length(toolParts);
		fprintf(fid, '"');
		for iB = 1:nTool-1,
			fprintf(fid, '%s,', toolParts{iB});
		end;
		fprintf(fid, '%s"), _\n', toolParts{nTool});				
	end;
	
	

	% Post-Amble.
	fprintf(fid, 'Array("NAME:IntersectParameters", _\n');
	fprintf(fid, '"KeepOriginals:=", %s) \n', Clone);
