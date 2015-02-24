function t_miqps_matpower(quiet)
%T_MIQPS_MATPOWER  Tests of MIQPS_MATPOWER MIQP solvers.

%   MATPOWER
%   $Id$
%   by Ray Zimmerman, PSERC Cornell
%   Copyright (c) 2010-2015 by Power System Engineering Research Center (PSERC)
%
%   This file is part of MATPOWER.
%   See http://www.pserc.cornell.edu/matpower/ for more info.
%
%   MATPOWER is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published
%   by the Free Software Foundation, either version 3 of the License,
%   or (at your option) any later version.
%
%   MATPOWER is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with MATPOWER. If not, see <http://www.gnu.org/licenses/>.
%
%   Additional permission under GNU GPL version 3 section 7
%
%   If you modify MATPOWER, or any covered work, to interface with
%   other modules (such as MATLAB code and MEX-files) available in a
%   MATLAB(R) or comparable environment containing parts covered
%   under other licensing terms, the licensors of MATPOWER grant
%   you additional permission to convey the resulting work.

if nargin < 1
    quiet = 0;
end

algs = {'CPLEX', 'MOSEK', 'GUROBI', 'GLPK', 'OT'};
names = {'CPLEX', 'MOSEK', 'Gurobi', 'glpk', 'intlin/lin/quadprog'};
check = {'cplex', 'mosek', 'gurobi', 'glpk', 'intlinprog'};
does_qp = [1 1 1 0 0];

n = 48;
nqp = 28;
nmiqp = 6;
t_begin(n*length(algs), quiet);

for k = 1:length(algs)
    if ~isempty(check{k}) && ~have_fcn(check{k})
        t_skip(n, sprintf('%s not installed', names{k}));
    else
        opt = struct('verbose', 0, 'alg', algs{k});
        if strcmp(names{k}, 'CPLEX')
%           alg = 0;        %% default uses barrier method with NaN bug in lower lim multipliers
            alg = 2;        %% use dual simplex
            mpopt = mpoption('cplex.lpmethod', alg, 'cplex.qpmethod', min([4 alg]));
            opt.cplex_opt = cplex_options([], mpopt);
        end
        if strcmp(names{k}, 'MOSEK')
            mpopt = mpoption;
%             sc = mosek_symbcon;
%             alg = sc.MSK_OPTIMIZER_DUAL_SIMPLEX;    %% use dual simplex
%             mpopt = mpoption(mpopt, 'mosek.lp_alg', alg );
            mpopt = mpoption(mpopt, 'mosek.gap_tol', 1e-10);
            opt.mosek_opt = mosek_options([], mpopt);
        end

        t = sprintf('%s - 3-d LP : ', names{k});
        %% based on example from 'doc linprog'
        c = [-5; -4; -6];
        A = [1 -1  1;
             -3  -2  -4;
             3  2  0];
        l = [-Inf; -42; -Inf];
        u = [20; Inf; 30];
        xmin = [0; 0; 0];
        x0 = [];
        [x, f, s, out, lam] = miqps_matpower([], c, A, l, u, xmin, [], [], [], opt);
        t_is(s, 1, 12, [t 'success']);
        t_is(x, [0; 15; 3], 6, [t 'x']);
        t_is(f, -78, 6, [t 'f']);
        t_is(lam.mu_l, [0;1.5;0], 9, [t 'lam.mu_l']);
        t_is(lam.mu_u, [0;0;0.5], 9, [t 'lam.mu_u']);
        t_is(lam.lower, [1;0;0], 9, [t 'lam.lower']);
        t_is(lam.upper, zeros(size(x)), 9, [t 'lam.upper']);

        if does_qp(k)
            t = sprintf('%s - unconstrained 3-d quadratic : ', names{k});
            %% from http://www.akiti.ca/QuadProgEx0Constr.html
            H = [5 -2 -1; -2 4 3; -1 3 5];
            c = [2; -35; -47];
            x0 = [0; 0; 0];
            [x, f, s, out, lam] = miqps_matpower(H, c, [], [], [], [], [], [], [], opt);
            t_is(s, 1, 12, [t 'success']);
            t_is(x, [3; 5; 7], 8, [t 'x']);
            t_is(f, -249, 13, [t 'f']);
            t_ok(isempty(lam.mu_l), [t 'lam.mu_l']);
            t_ok(isempty(lam.mu_u), [t 'lam.mu_u']);
            t_is(lam.lower, zeros(size(x)), 13, [t 'lam.lower']);
            t_is(lam.upper, zeros(size(x)), 13, [t 'lam.upper']);
        
            t = sprintf('%s - constrained 2-d QP : ', names{k});
            %% example from 'doc quadprog'
            H = [   1   -1;
                    -1  2   ];
            c = [-2; -6];
            A = [   1   1;
                    -1  2;
                    2   1   ];
            l = [];
            u = [2; 2; 3];
            xmin = [0; 0];
            x0 = [];
            [x, f, s, out, lam] = miqps_matpower(H, c, A, l, u, xmin, [], x0, [], opt);
            t_is(s, 1, 12, [t 'success']);
            t_is(x, [2; 4]/3, 7, [t 'x']);
            t_is(f, -74/9, 6, [t 'f']);
            t_is(lam.mu_l, [0;0;0], 13, [t 'lam.mu_l']);
            t_is(lam.mu_u, [28;4;0]/9, 7, [t 'lam.mu_u']);
            t_is(lam.lower, zeros(size(x)), 7, [t 'lam.lower']);
            t_is(lam.upper, zeros(size(x)), 13, [t 'lam.upper']);

            t = sprintf('%s - constrained 4-d QP : ', names{k});
            %% from http://www.jmu.edu/docs/sasdoc/sashtml/iml/chap8/sect12.htm
            H = [   1003.1  4.3     6.3     5.9;
                    4.3     2.2     2.1     3.9;
                    6.3     2.1     3.5     4.8;
                    5.9     3.9     4.8     10  ];
            c = zeros(4,1);
            A = [   1       1       1       1;
                    0.17    0.11    0.10    0.18    ];
            l = [1; 0.10];
            u = [1; Inf];
            xmin = zeros(4,1);
            x0 = [1; 0; 0; 1];
            [x, f, s, out, lam] = miqps_matpower(H, c, A, l, u, xmin, [], x0, [], opt);
            t_is(s, 1, 12, [t 'success']);
            t_is(x, [0; 2.8; 0.2; 0]/3, 5, [t 'x']);
            t_is(f, 3.29/3, 6, [t 'f']);
            t_is(lam.mu_l, [6.58;0]/3, 6, [t 'lam.mu_l']);
            t_is(lam.mu_u, [0;0], 13, [t 'lam.mu_u']);
            t_is(lam.lower, [2.24;0;0;1.7667], 4, [t 'lam.lower']);
            t_is(lam.upper, zeros(size(x)), 13, [t 'lam.upper']);

            t = sprintf('%s - (struct) constrained 4-d QP : ', names{k});
            p = struct('H', H, 'A', A, 'l', l, 'u', u, 'xmin', xmin, 'x0', x0, 'opt', opt);
            [x, f, s, out, lam] = miqps_matpower(p);
            t_is(s, 1, 12, [t 'success']);
            t_is(x, [0; 2.8; 0.2; 0]/3, 5, [t 'x']);
            t_is(f, 3.29/3, 6, [t 'f']);
            t_is(lam.mu_l, [6.58;0]/3, 6, [t 'lam.mu_l']);
            t_is(lam.mu_u, [0;0], 13, [t 'lam.mu_u']);
            t_is(lam.lower, [2.24;0;0;1.7667], 4, [t 'lam.lower']);
            t_is(lam.upper, zeros(size(x)), 13, [t 'lam.upper']);
        else
            t_skip(nqp, sprintf('%s does not handle QP problems', names{k}));
        end

        t = sprintf('%s - infeasible LP : ', names{k});
        p = struct('A', sparse([1 1]), 'c', [1;1], 'u', -1, 'xmin', [0;0], 'opt', opt);
        [x, f, s, out, lam] = miqps_matpower(p);
        t_ok(s <= 0, [t 'no success']);

% opt.verbose = 3;
        t = sprintf('%s - 2-d MILP : ', names{k});
        %% from MOSEK 6.0 Guided Tour, section  7.13.1, http://docs.mosek.com/6.0/toolbox/node009.html#283040944
        c = [-2; -3];
        A = sparse([195 273; 4 40]);
        u = [1365; 140];
        xmax = [4; Inf];
        vtype = 'I';
        p = struct('c', c, 'A', A, 'u', u, 'xmax', xmax, 'vtype', vtype, 'opt', opt);
        [x, f, s, out, lam] = miqps_matpower(p);
        t_is(s, 1, 12, [t 'success']);
        t_is(x, [4; 2], 12, [t 'x']);
        t_is(lam.mu_l, [0; 0], 12, [t 'lam.mu_l']);
        t_is(lam.mu_u, [0; 0], 12, [t 'lam.mu_u']);
        t_is(lam.lower, [0; 0], 12, [t 'lam.lower']);
        t_is(lam.upper, [2; 3], 12, [t 'lam.upper']);

        if does_qp(k)
            t = sprintf('%s - 4-d MIQP : ', names{k});
            %% from cplexmiqpex.m, CPLEX_Studio_Academic124/cplex/examples/src/matlab/cplexmiqpex.m
            H = sparse([ 33   6    0    0;
                          6  22   11.5  0;
                          0  11.5 11    0;
                          0   0    0    0]);
            c = [-1 -2 -3 -1]';
            Aineq = [-1  1  1 10;
               1 -3  1  0];
            bineq = [20  30]';
            Aeq   = [0  1  0 -3.5];
            beq   =  0;
            xmin    = [ 0;   0;   0; 2];
            xmax    = [40; Inf; Inf; 3];
            A = sparse([Aeq; Aineq]);
            l = [beq; -Inf; -Inf];
            u = [beq; bineq];
            vtype = 'CCCI';
            p = struct('H', H, 'c', c, 'A', A, 'l', l, 'u', u, ...
                'xmin', xmin, 'xmax', xmax, 'vtype', vtype, 'opt', opt);
            [x, f, s, out, lam] = miqps_matpower(p);
            t_is(s, 1, 12, [t 'success']);
            t_is(x, [7; 7; 0; 2], 7, [t 'x']);
            t_is(lam.mu_l, [466; 0; 0], 6, [t 'lam.mu_l']);
            t_is(lam.mu_u, [0; 272; 0], 6, [t 'lam.mu_u']);
            t_is(lam.lower, [0; 0; 349.5; 4350], 5, [t 'lam.lower']);
            t_is(lam.upper, [0; 0; 0; 0], 7, [t 'lam.upper']);
        else
            t_skip(nmiqp, sprintf('%s does not handle MIQP problems', names{k}));
        end
% opt.verbose = 0;
    end
end

t_end;
