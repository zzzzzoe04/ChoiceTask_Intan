% try plotting channel 1 of a lfp_NNsite file for the first correctgo trial for eventFieldnames cueOn and centerIn of the data


subplot(5,1,1);
plot(lfp_NNsite_order(1, 415093:495093));
set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
hold on

subplot(5,1,2);
plot(lfp_NNsite_order(2, 415093:495093));
set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);


subplot(5,1,3);
plot(lfp_NNsite_order(3, 415093:495093));
set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);


hold off