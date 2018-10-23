SHELL=/bin/bash

figures/map_all.png: tables/dataset_stats.tsv figures/pairwise.png
	R --no-save < createMaps.R

tables/dataset_stats.tsv:
	# retrieve dataset info
	R --no-save < generate_dataset_report.R
	cut -f2- namespace_datasets.tsv  | sort > namespace_datasets_sorted.tsv
	cat namespace_formats.tsv | sort > namespace_formats_sorted.tsv
	# merge info with formats
	join -t $$'\t' namespace_datasets_sorted.tsv namespace_formats_sorted.tsv > dataset_formats.tsv
	cat dataset_formats.tsv | cut -f1,2,3,4,5,8,10 | awk -F '\t' '{ print $$3 "\t" $$2 "\t" $$7 "\t" $$1 "\t" $$5 "\t" $$6 }' | sort | uniq | sort -nr > dataset_stats_no_header.tsv
	# add header
	echo -e "n_interactions\tn_taxa\tformat\tnamespace\tcitation\tdateAccessed" | cat - dataset_stats_no_header.tsv | sed -e 's/"//g' > tables/dataset_stats.tsv

figures/pairwise.png:
	dot -Tpng pairwise.dot > figures/pairwise.png
	dot -Tpng n-ary.dot > figures/n-ary.png
	dot -Tpng network.dot > figures/network.png
	dot -Tpng network-as-pairwise.dot > figures/network-as-pairwise.png
	dot -Tpng n-ary-support-refute.dot > figures/n-ary-support-refute.png
