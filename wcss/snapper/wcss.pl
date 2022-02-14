



open(FIN,"mcmc.xml")or die "Cannot open file mcmc.xml";
$template = "";
while ($s = <FIN>) {
	$template .= $s;
}
close FIN;

chdir "templates";
for ($i = 1; $i <= 100; $i++) {


	chdir "rep$i/";
	print `pwd`;

	open(FTREE,"trueSpecies.newick") or die "Cannot open file trueSpecies.newick";
	$tree = <FTREE>;
	

	
	open (FOUT,">simsnap.cfg");
	print FOUT '40
species1 4
species2 4
species3 4
species4 4
species5 4
species6 4
species7 4
species8 4
species9 4
species10 4
species11 4
species12 4
species13 4
species14 4
species15 4
species16 4
species17 4
species18 4
species19 4
species20 4
species21 4
species22 4
species23 4
species24 4
species25 4
species26 4
species27 4
species28 4
species29 4
species30 4
species31 4
species32 4
species33 4
species34 4
species35 4
species36 4
species37 4
species38 4
species39 4
species40 4
0.5 0.5
1
';
print FOUT $tree;
	close FOUT;
	print `~/SNAPP/SimSnap/simsnap -n 100 simsnap.cfg`;
	print `~/beast/beast/bin/applauncher Nexus2Fasta -in simsnap_tree_1.nex -o simsnap.fas`;
	
	
	$alignment = "";
	open(FIN,"simsnap.fas");
	while ($s =<FIN>) {
		$taxon = $s;
		chomp($taxon);
		$taxon =~ s/>//;
		$seq = <FIN>;
		chomp($seq);
		$alignment .= "<sequence spec='Sequence' taxon='$taxon' totalcount='2' value='$seq'/>\n";
	}
	close FIN;
	
	
	
	open(FOUT,">mcmc.xml");
	$xml = $template;
	$xml =~ s/simsnap/$alignment/;
	print FOUT $xml;
	close FOUT;	
	
	
	chdir "..";
	
}


