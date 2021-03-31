#!/usr/bin/awk -f

BEGIN{
	FS="\t";OFS="\t";}
{
	if($2=="16"){
		$2="0";}
	else{
		if($2=="0"){
			$2="16";}
		}
print $_;
}