function out = SerializeVector(x, tol)
  % Serializes a numeric vector. 
  numLines = length(x);
  lines = cell(numLines,1);
  if (nargin == 1)
    tol = '';
  else 
    tol = sprintf(':%s', tol);
  end
  for i=1:numLines
    lines{i} = sprintf('%.4f%s\n', x(i), tol);
  end
  out = sprintf('%s', lines{:});
end
  