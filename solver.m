function solver(varargin)
% Under GPLv3
% Author: zaazwm <https://github.com/zaazwm/>

    if nargin<=3
        fprintf('Usage: [move] [target] [init] [ops]+\n');
        return;
    end
    
    move = str2num(varargin{1});
    target = str2num(replace(varargin{2},'m','-'));
    init = str2num(replace(varargin{3},'m','-'));
    
    ops = zeros(nargin-4, 3); % [type] [i1] [i2]
    % type 1:+/- 2:<< 3:=> 4:+ 5:- 6:append 7:* 8:/ 9:Reverse 10:Inv10 11:Sum 12:x^n 13:<Shift 14:Shift> 15:Mirror 16:[+]n 17:Store 18:Portal 
    for i=4:nargin
        switch varargin{i}
            case {'+-','+/-','c'}
                ops(i-3, :) = [1,0,0];
            case {'<<','l'}
                ops(i-3, :) = [2,0,0];
            case {'R','r','Reverse'}
                ops(i-3, :) = [9,0,0];
            case {'I','i','Inv10'}
                ops(i-3, :) = [10,0,0];
            case {'S','s','SUM'}
                ops(i-3, :) = [11,0,0];
            case {'<','z','Z','<Shift'}
                ops(i-3, :) = [13,0,0];
            case {'>','x','X','Shift>'}
                ops(i-3, :) = [14,0,0];
            case {'m','M','Mirror'}
                ops(i-3, :) = [15,0,0];
            case {'g','G','Store'}
                ops(i-3, :) = [17,0,0];
            otherwise
                if contains(varargin{i}, '=>')
                    nums = split(varargin{i}, '=>');
                    if length(nums)~=2
                        error('unknown ops "%s" !', varargin{i});
                    end
                    ops(i-3, :) = [3,str2num(nums{1}),str2num(['1' nums{2}])];
                elseif contains(varargin{i}, '>')
                    nums = split(varargin{i}, '>');
                    if length(nums)~=2
                        error('unknown ops "%s" !', varargin{i});
                    end
                    ops(i-3, :) = [3,str2num(nums{1}),str2num(['1' nums{2}])];
                elseif contains(varargin{i}, 'b')
                    nums = split(varargin{i}, 'b');
                    if length(nums)~=2
                        error('unknown ops "%s" !', varargin{i});
                    end
                    ops(i-3, :) = [3,str2num(nums{1}),str2num(['1' nums{2}])];
                elseif contains(varargin{i}, 'p')
                    nums = split(varargin{i}, 'p');
                    if length(nums)~=2
                        error('unknown ops "%s" !', varargin{i});
                    end
                    ops(i-3, :) = [18,str2num(nums{1}),str2num(nums{2})];
                elseif contains(varargin{i}, 'P')
                    nums = split(varargin{i}, 'P');
                    if length(nums)~=2
                        error('unknown ops "%s" !', varargin{i});
                    end
                    ops(i-3, :) = [18,str2num(nums{1}),str2num(nums{2})];
                else
                    switch varargin{i}(1)
                        case {'+','a'}
                            ops(i-3, :) = [4,str2num(varargin{i}(2:end)), 0];
                        case {'-','m'}
                            ops(i-3, :) = [5,str2num(varargin{i}(2:end)), 0];
                        case {'*','x','t'}
                            ops(i-3, :) = [7,str2num(replace(varargin{i}(2:end),'m','-')), 0];
                        case {'/','d'}
                            ops(i-3, :) = [8,str2num(replace(varargin{i}(2:end),'m','-')), 0];
                        case {'^','p'}
                            ops(i-3, :) = [12,str2num(replace(varargin{i}(2:end),'m','-')), 0];
                        case '['
                            switch varargin{i}(2)
                                case '+'
                                    ops(i-3, :) = [16,str2num(replace(varargin{i}(4:end),'m','-')), 0];
                                case '-'
                                    ops(i-3, :) = [16,-1*str2num(replace(varargin{i}(4:end),'m','-')), 0];
                                otherwise
                                    error('unknown ops "%s" !', varargin{i});
                            end
                        case 'c'
                            ops(i-3, :) = [16,str2num(replace(varargin{i}(2:end),'m','-')), 0];
                        otherwise
                            ops(i-3, :) = [6,str2num(varargin{i}), 0];
                    end
                end
        end
    end
    
    order = DFS(move, target, init, ops);
    
    after_store=false;
    skip_list = [];
    for i=length(order):-1:1
        if order(i)~=99
            if ops(order(i),1)==17
                after_store=true;
            end
        else
            if after_store
                after_store=false;
            else
                skip_list = [skip_list i];
            end
        end
    end
    
    base = 0;
    for i=setdiff(1:length(order), skip_list)
        [str, base] = print_op(ops, order(i), base);
        fprintf('%s\n', str);
    end
end

function [str, base] = print_op(ops, idx, base)
    if idx==99
        str = 'Store2MEM';
        return;
    end
    switch ops(idx,1)
        case 1
            str = '+/-';
        case 2
            str = '<<';
        case 3
            to_num = num2str(ops(idx,3));
            str = sprintf('%d=>%s', ops(idx,2),to_num(2:end));
        case 4
            str = sprintf('+%d', ops(idx,2)+base);
        case 5
            str = sprintf('-%d', ops(idx,2)+base);
        case 6
            str = sprintf('%d', ops(idx,2)+base);
        case 7
            str = sprintf('x%d', ops(idx,2)+base);
        case 8
            str = sprintf('/%d', ops(idx,2)+base);
        case 9
            str = 'Reverse';
        case 10
            str = 'Inv10';
        case 11
            str = 'SUM';
        case 12
            str = sprintf('x^%d', ops(idx,2));
        case 13
            str = '<Shift';
        case 14
            str = 'Shift>';
        case 15
            str = 'Mirror';
        case 16
            str = sprintf('[+]%d', ops(idx,2));
            base = base + ops(idx,2);
        case 17
            str = 'Store';
        otherwise
            error('unknown operation!');
    end
end

function str = print_op_str(op)
% @deprecated
    switch op
        case {'+-','c'}
            str = '+/-';
        case {'<<','l'}
            str = '<<';
        case {'R','r'}
            str = 'Reverse';
        case {'I','i'}
            str = 'Inv10';
        case {'S','s'}
            str = 'SUM';
        case {'<','z','Z'}
            str = '<Shift';
        case {'>','x','X','Shift>'}
            str = 'Shift>';
        case {'m','M','Mirror'}
            str = 'Mirror';
        otherwise
            if contains(op, '>')
                if ~contains(op, '=>')
                    str = replace(op, '>', '=>');
                else
                    str = op;
                end
            elseif contains(op, 'b')
                str = replace(op, 'b', '=>');
            else
                switch op(1)
                    case 'a'
                        str = ['+' op(2:end)];
                    case 'm'
                        str = ['-' op(2:end)];
                    case {'*','t'}
                        str = ['x' op(2:end)];
                    case 'd'
                        str = ['/' op(2:end)];
                    case {'^','p'}
                        str = ['x^' op(2:end)];
                    case 'c'
                        str = ['[+]' op(2:end)];
                    otherwise
                        str = op;
                end
            end
            str = replace(str, 'm','-');
    end
end

function order = DFS(move, target, init, ops)
    if sum(ops(:,1)==18)==1
        portal = ops(ops(:,1)==18,2:end);
        pt = num2str(portal(2));
        pt = pt-'0';
        portal = [portal(1) max(pt)];
    else
        portal = [];
    end

    order = DFS_K(move, target, init, ops, 0, [], portal);
    
    if isempty(order) % store to memory at first
        order = DFS_K(move, target, init, ops, 0, init, portal);
        
        if isempty(order)
            error('sorry, operation list not found, cannot solve it!');
        else
            order = [99, order];
        end
    end
end

function order = DFS_K(move, target, input, ops, base, store, portal)
    ops_sz = size(ops, 1);
    order = [];
    for i=1:ops_sz
        result = [];
        new_base = base;
        switch ops(i, 1)
            case 1
                result = input * -1;
            case 2
                result = floor(input/10);
            case 3
                res_str = num2str(input);
                to_num = num2str(ops(i,3));
                res_str = replace(res_str, num2str(ops(i,2)), to_num(2:end));
                result = str2num(res_str);
            case 4
                result = input + (ops(i,2) + base);
            case 5
                result = input - (ops(i,2) + base);
            case 6
                res_str = num2str(input);
                res_str = [res_str num2str(ops(i,2)+base)];
                result = str2num(res_str);
            case 7
                result = input * (ops(i,2) + base);
            case 8
                result = input / (ops(i,2) + base);
            case 9
                i_sign = sign(input);
                res_str = num2str(abs(input));
                res_str = reverse(res_str);
                result = i_sign * str2num(res_str);
            case 10
                i_sign = sign(input);
                res_str = num2str(abs(input));
                res_str = mod(10-(res_str-'0'), 10);
                result = i_sign * str2num(sprintf('%s', res_str+'0'));
            case 11
                i_sign = sign(input);
                res_str = num2str(abs(input));
                result = sum(res_str-'0');
                result = i_sign * result;
            case 12
                result = input ^ ops(i,2);
            case 13
                i_sign = sign(input);
                res_str = num2str(abs(input));
                result = i_sign * str2num([res_str(2:end) res_str(1)]);
            case 14
                i_sign = sign(input);
                res_str = num2str(abs(input));
                result = i_sign * str2num([res_str(end) res_str(1:end-1)]);
            case 15
                i_sign = sign(input);
                res_str = num2str(abs(input));
                res_str = [res_str reverse(res_str)];
                result = i_sign * str2num(res_str);
            case 16
                new_base = base + ops(i,2);
                result = input;
            case 17
                if ~isempty(store)
                    res_str = num2str(input);
                    res_str = [res_str num2str(store)];
                    result = str2num(res_str);
                end
        end
        
        if isempty(result)
            continue;
        end
        if floor(result)~=result
            continue;
        end
        if result>999999 || result<-99999
            continue;
        end
        if ~isempty(portal) 
            r_sign = sign(result);
            res_str = num2str(abs(result));
            res_str = fliplr(res_str);
            if length(res_str)>=max(portal)
                while length(res_str)>=max(portal)
                    to_num = str2num(res_str(portal(1)));
                    res_str(portal(1))=[];
                    residual = fliplr(res_str);
                    residual = str2num(residual);
                    for j=2:length(portal)
                        residual = residual + to_num * (10^(portal(j)-1));
                    end
                    res_str = num2str(residual);
                    res_str = fliplr(res_str);
                end
                result = r_sign * residual;
            end
        end
        if input==result && new_base==base
            continue;
        end
        
        %[debug_str, ~] = print_op(ops, i, base);
        %fprintf('DEBUG: op=%s, res=%d, base=%d, move=%d\n',debug_str,result,new_base,move);
        
        if move==1
            if result~=target
                continue;
            else
                order=i;
            end
        elseif move>1
            if result==target
                order = i;
            else
                post_order = DFS_K(move-1, target, result, ops, new_base, store, portal);
                if ~isempty(post_order)
                    if isempty(order) || length(order)>length(post_order)+1
                        order = [i, post_order];
                    end
                elseif result~=store  % store to memory
                    post_order = DFS_K(move-1, target, result, ops, new_base, result, portal);
                    if ~isempty(post_order)
                        if isempty(order) || length(order)>length(post_order)+1
                            order = [i, 99, post_order];
                        end
                    end
                end
            end
        end
    end
end