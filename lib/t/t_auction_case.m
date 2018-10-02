function [baseMVA, bus, gen, branch, areas, gencost] = t_auction_case
%T_AUCTION_CASE    Power flow data for testing auction code.
%   Please see CASEFORMAT for details on the case file format.

%   MATPOWER

%%-----  Power Flow Data  -----%%
%% system MVA base
baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
bus = [
	1	3	0	0	0	0	1	1	0	135	1	1.05	0.95;
	2	2	5.04485072	2.95251632	0	0	1	1	0	135	1	1.1	0.95;
	3	1	22.3182336	11.1591168	0	0	1	1	0	135	1	1.05	0.95;
	4	1	8.8343008	1.8598528	0	0	1	1	0	135	1	1.05	0.95;
	5	1	0	0	0	0.19	1	1	0	135	1	1.05	0.95;
	6	1	0	0	0	0	1	1	0	135	1	1.05	0.95;
	7	2	0	0	0	0	1	1	0	135	1	1.05	0.95;
	8	1	13.948896	13.948896	0	0	1	1	0	135	1	1.05	0.95;
	9	1	0	0	0	0	1	1	0	135	1	1.05	0.95;
	10	1	6.7419664	2.324816	0	0	3	1	0	135	1	1.05	0.95;
	11	1	0	0	0	0	1	1	0	135	1	1.05	0.95;
	12	1	13.0189696	8.71806	0	0	2	1	0	135	1	1.05	0.95;
	13	2	0	0	0	0	2	1	0	135	1	1.1	0.95;
	14	1	7.2069296	1.8598528	0	0	2	1	0	135	1	1.05	0.95;
	15	2	0	0	0	0	2	1	0	135	1	1.05	0.95;
	16	1	4.068428	2.0923344	0	0	2	1	0	135	1	1.05	0.95;
	17	1	10.461672	6.7419664	0	0	2	1	0	135	1	1.05	0.95;
	18	1	3.7197056	1.0461672	0	0	2	1	0	135	1	1.05	0.95;
	19	1	11.042876	3.9521872	0	0	2	1	0	135	1	1.05	0.95;
	20	1	2.5572976	0.8136856	0	0	2	1	0	135	1	1.05	0.95;
	21	1	3.39036344738	2.1698326063232	0	0	3	1	0	135	1	1.05	0.95;
	220	2	0	0	0	0	3	1	0	135	1	1.1	0.95;
	23	2	22.3182336	11.1591168	0	0	2	1	0	135	1	1.1	0.95;
	24	1	10.1129496	7.7881336	0	0.04	3	1	0	135	1	1.05	0.95;
	25	1	0	0	0	0	3	1	0	135	1	1.05	0.95;
	26	1	4.068428	2.6735384	0	0	3	1	0	135	1	1.05	0.95;
	27	2	0	0	0	0	3	1	0	135	1	1.1	0.95;
	28	1	0	0	0	0	1	1	0	135	1	1.05	0.95;
	29	1	2.7897792	1.0461672	0	0	3	1	0	135	1	1.05	0.95;
	30	2	0	0	0	0	3	1	0	135	1	1.05	0.95;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin
gen = [
	1	23.54	0	60	-15	1	100	1	60	35;
	2	60.97	0	60	-15	1	100	1	60	12;
	220	21.59	0	60	-15	1	100	1	60	12;
	27	26.91	0	60	-15	1	100	1	60	12;
	23	19.2	0	60	-15	1	100	1	60	12;
	13	37	0	60	-15	1	100	1	60	12;
	7	-30	-15	0	-15	1	100	1	0	-30;
	15	-30	-12	0	-12	1	100	1	0	-30;
	30	-10	-2.5	0	-7.5	1	100	1	0	-30;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status
branch = [
	1	2	0.02	0.06	0.03	10000	130	130	0	0	1;
	1	3	0.05	0.19	0.02	10000	130	130	0	0	1;
	2	4	0.06	0.17	0.02	10000	65	65	0	0	1;
	3	4	0.01	0.04	0	10000	130	130	0	0	1;
	2	5	0.05	0.2	0.02	10000	130	130	0	0	1;
	2	6	0.06	0.18	0.02	10000	65	65	0	0	1;
	4	6	0.01	0.04	0	10000	90	90	0	0	1;
	5	7	0.05	0.12	0.01	10000	70	70	0	0	1;
	6	7	0.03	0.08	0.01	10000	130	130	0	0	1;
	6	8	0.01	0.04	0	10000	32	32	0	0	1;
	6	9	0	0.21	0	10000	65	65	0	0	1;
	6	10	0	0.56	0	10000	32	32	0	0	1;
	9	11	0	0.21	0	10000	65	65	0	0	1;
	9	10	0	0.11	0	10000	65	65	0	0	1;
	4	12	0	0.26	0	10	65	65	0	0	1;
	12	13	0	0.14	0	10000	65	65	0	0	1;
	12	14	0.12	0.26	0	10000	32	32	0	0	1;
	12	15	0.07	0.13	0	10000	32	32	0	0	1;
	12	16	0.09	0.2	0	10000	32	32	0	0	1;
	14	15	0.22	0.2	0	10000	16	16	0	0	1;
	16	17	0.08	0.19	0	10000	16	16	0	0	1;
	15	18	0.11	0.22	0	10000	16	16	0	0	1;
	18	19	0.06	0.13	0	10000	16	16	0	0	1;
	19	20	0.03	0.07	0	10000	32	32	0	0	1;
	10	20	0.09	0.21	0	10000	32	32	0	0	0;
	10	17	0.03	0.08	0	10000	32	32	0	0	0;
	10	21	0.03	0.07	0	10000	32	32	0	0	1;
	10	220	0.07	0.15	0	10000	32	32	0	0	1;
	21	220	0.01	0.02	0	10000	32	32	0	0	1;
	15	23	0.1	0.2	0	10000	16	16	0	0	1;
	22	24	0.12	0.18	0	10000	16	16	0	0	1;
	23	24	0.13	0.27	0	10	16	16	0	0	1;
	24	25	0.19	0.33	0	10000	16	16	0	0	1;
	25	26	0.25	0.38	0	10000	16	16	0	0	1;
	25	27	0.11	0.21	0	10000	16	16	0	0	1;
	28	27	0	0.4	0	10000	65	65	0	0	1;
	27	29	0.22	0.42	0	10000	16	16	0	0	1;
	27	30	0.32	0.6	0	10000	16	16	0	0	1;
	29	30	0.24	0.45	0	10000	16	16	0	0	1;
	8	28	0.06	0.2	0.02	10000	32	32	0	0	1;
	6	28	0.02	0.06	0.01	10000	32	32	0	0	1;
];

%%-----  OPF Data  -----%%
%% area data
%	area	refbus
areas = [
	1	8;
	2	23;
	3	26;
];

%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
gencost = [
	1	0	0	4	0	0	12	240	36	1200	60	2400;
	1	0	0	4	0	0	12	240	36	1200	60	2400;
	1	0	0	4	0	0	12	240	36	1200	60	2400;
	1	0	0	4	0	0	12	240	36	1200	60	2400;
	1	0	0	4	0	0	12	240	36	1200	60	2400;
	1	0	0	4	0	0	12	240	36	1200	60	2400;
	1	0	0	4	-30	-3000	-20	-2000	-10	-1000	0	0;
	1	0	0	4	-30	-3000	-20	-2000	-10	-1000	0	0;
	1	0	0	4	-30	-3000	-20	-2000	-10	-1000	0	0;
];
