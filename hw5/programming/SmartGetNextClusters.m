%GETNEXTCLUSTERS Takes in a cluster graph and returns the indices
%   of the nodes between which the next message should be passed.
%
%   [i j] = SmartGetNextClusters(P,Messages,oldMessages,m,useSmart)
%
%   INPUT
%     P - our cluster graph
%     Messages - the current values of all messages in P
%     oldMessages - the previous values of all messages in P. Thus, 
%         oldMessages(i,j) contains the value that Messages(i,j) contained 
%         immediately before it was updated to its current value
%     m - the index of the message we are passing (ie, m=0 indicates we have
%         passed 0 messages prior to this one. m=5 means we've passed 5 messages
%
%     Implement any message passing routine that will converge in cases that the
%     naive routine would also converge.  You may also change the inputs to
%     this function, but note you may also have to change GetNextClusters.m as
%     well.


function [i j] = SmartGetNextClusters(P,Messages,oldMessages,m)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Find the indices between which to pass a cluster
    % The 'find' function may be useful
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global BPorder;
    [row,col] = find(P.edges~=0);
    N = length(row);
    if(mod(m,N)==1)
        diff = zeros(1,N);
        for k=1:N
            ix1 = row(k);
            ix2 = col(k);
            diff(k) = max(abs(Messages(ix1,ix2).val-oldMessages(ix1,ix2).val));
        end
        [B BPorder]=sort(diff,'ascend');
    end
    indx=BPorder(mod(m-1,N)+1);
    i=row(indx);
    j=col(indx);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

