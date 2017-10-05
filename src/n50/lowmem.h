#include <iomanip>  //setprecision
#include <algorithm>    // sort, reverse
#include <gzstream.h>
#include <vector>  //setprecision
#include <tuple> // C++11, for std::tie
#include <numeric> // accumulate
#include <zlib.h>
#include <stdio.h>
#include <iostream>
#include <fstream>

using std::cout;
using std::endl;
using std::vector;
using std::string;

static gzFile fp;
static  vector<int> rlen;
static  vector<string> rseq;
static  vector<string> rqual;
static  vector<string> rname;
static  vector<string> rcomment;


// ---------------------------------------- //
int fasttype(char* file)
// ---------------------------------------- //
{ 
  char fq[5]={"@"};
  char fa[5]={">"};
  string ttname;
  int isfq=0;
  igzstream infile(file);

  getline(infile,ttname);
  string ftype=ttname.substr(0,1);
  if(ftype==fa) isfq=0;
  else isfq=1;

  return(isfq);
}


// ---------------------------------------- //
int readfastq(char* file)
// ---------------------------------------- //
{ 
  igzstream infile(file);
  char fq[5]={"@"};
  char plus[5]={"+"};
  int nseq=0;
 
  rlen.reserve(100000);

  string read;
  int seqlen=0;
  int quallen=0;
  int seqlines=0;


  int stop=1;
  while(stop){
    getline(infile,read);
    
    if(read.substr(0,1)==fq){  // name
      nseq++;

      if(nseq>1) {// previous
	rlen.push_back(seqlen);
	if(seqlen != quallen) cout << " Error! seqlen != qual-len"
				 << seqlen << " " << quallen << endl;
      }

      //reset
      seqlen=0;
      seqlines=0;
      quallen=0;

    }else if(read.substr(0,1)==plus){ // + and qual
      for(int ll=0; ll<seqlines; ll++){
	getline(infile,read);
	quallen+=read.size();
      }
    }else{ // sequence 
      seqlines++;
      seqlen+=read.size();
    }
 
    // EOF
    if(infile.eof()){ // previous
      rlen.push_back(seqlen);
      stop=0;
    }

  }//read loop
 
  return 0;
}


// ---------------------------------------- //
int readfasta(char* file)
// ---------------------------------------- //
{ 
  igzstream infile(file);
  char fa[5]={">"};
  int nseq=0;

  rlen.reserve(100000);
 
  string read;
  int seqlen=0;

  int stop=1;
  while(stop){
    getline(infile,read);
    
    if(read.substr(0,1)==fa){  // name
      nseq++;

      if(nseq>1) // previous
	rlen.push_back(seqlen);
      
      //reset
      seqlen=0;

    }else{ // sequence 
      seqlen+=read.size();
    }
 
    // EOF
    if(infile.eof()){ // previous
      rlen.push_back(seqlen);
      stop=0;
    }
  }//read loop
 
  return 0;
}

