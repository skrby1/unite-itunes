#!/usr/bin/env perl -w
use strict;

my @ps_vim = split(/\n/, `ps auxw | grep -ie "vim"`);

my $macvimPID = "";
my $vimPID = "";
foreach(@ps_vim){
  if($_ !~ /grep -ie/){
    my @list = split(/\s+/, $_);
    $macvimPID = $list[1] if $list[-1] =~ /MacVim/;
    $vimPID = $list[1] if $list[-1] =~ /vim/;
  }
}

my $activate;
if($macvimPID ne ""){
  $activate = "MacVim";
}elsif($vimPID ne ""){
  $activate = "Terminal";
}else{
  $activate = $macvimPID > $vimPID ? "MacVim" : "Terminal";
}

print "$activate";
