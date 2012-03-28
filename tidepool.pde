/*
Tidepool processing.js script - this is where the magic happens

File History:
3/27/2012 Michael J. DeLuca michaeljdeluca@gmail.com split into its own file, moved instance-specific variables to top of file for ease of editing

Creative Commons:
Tidepool was created by Don Blair and is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. Dark Ally Redesign™, a project by Stephanie Jo Kent, is an education and consulting company specializing in discourse diagnosis and design for systems change. Follow us on Twitter! @adarkally @stephjoke

*/

//the Twitter hashtag we're going to track
String searchTerm = '#OWS';

// this string contains words that we don't want to consider for display.
String stopwordsString = "a about above after again ago all almost along already also although always am among an and another any anybody anything anywhere are aren't around as at back else be been before being below beneath beside between beyond both each but by can can't could couldn't did didn't do does doesn't doing done don't down during either enough even ever every everybody everyone everything everywhere except far few fewer first for from get gets getting got had hadn't has hasn't have haven't having he he'd he'll hence her here hers herself he's him himself his hither how however near i i'd if i'll i'm in into is i've isn't it its it's itself last less many me may might mine more most much must mustn't my myself near nearby nearly neither never next no nobody none noone nothing nor not now nowhere of off often on or once one only other others ought oughtn't our ours ourselves out over quite rather round second shall shan't she'd she she'll she's should shouldn't since so some somebody someone something sometimes somewhere soon still such than that that's the their theirs them themselves these then thence there therefore they they'd they'll they're this thither those though through thus till to towards today tomorrow too under underneath unless until up us very when was wasn't we we'd we'll were we're weren't we've what whence where whereas which while whither who whom whose why will with within without won't would wouldn't yes yesterday yet you your you'd you'll you're yours yourself yourselves you've theyre weve dont thats because #owshttp t quot s u don The amp New via said If //t PM Occupy I fuck shit UC cum #tits 2 @ A It e re nt t - -- like see What Don In d" + searchTerm + searchTerm.toLowerCase() + searchTerm.toUpperCase();

// we split this string into an array, to facilitate comparison with words from tweets
String [] stopwords = split(stopwordsString, " ");

// class Tweet contains the tweet that comes in
class Tweet {
      public String id;
      public String profileName;
      public String profileImageUrl;
      public String text;
      public Date time;
    }

// visualization parameters
float spring = .3;

float gravity=0.0;
float friction = -0.6;
float myFriction=.6;
int boxSize = 600;
int boxSizeX=boxSize;
int boxSizeY=boxSize;
float areaFrac=.64;

HashMap hashwords;  // HashMap object that will contain all the words that come in from the tweets
int numTerms=0;
int numbuzzwords;
int maxBuzzwords=100;
int numTweetsAnalyzed=0;

float bx,by;
boolean bover = false;
boolean locked = false;
float bdifx = 0.0;
float bdify = 0.0;

// CLASS WORD is an on object that stores the words that come in from the Tweets.
// It contains methods for displaying the word as a bubble on the screen, as well as interacting with other bubbles.
class Word  {
  
  // visualization data
  float x,y;
  float radius;
  float vx = 0.;
  float vy = 0.;

  int count;
  String word;
  int ID;

  Word(String s) {
    word = s;
    count = 1;
    x= random(boxSizeX);
    y= random(boxSizeY);
    //x= 30;
    //y= 30;
    //y=30;
    radius = (float) count;
    boolean mouseOverMe=false;
  }
  void count() {
    count=count+1;
  }
  int compareTo(Object o)
  {
    Word other=(Word)o;
    if (other.count>count) return -1;
    if (other.count==count) return 0;
    else return 1;
  }

  // visualization

  void display() {
    //fill(255,20);
    //radius=20;
    fill(200,100);
    fill(200,0,0);
    float xlim, ylim;
    //textSize(radius/3);
    float tw = textWidth(word);
    /*if (tw>(2*radius)) {
      radius=tw*1.2
    }
    */
    //fill((count/topcount)*100+100);
    //fill(100);


    // test if mouse if over the circle
    float dx = mouseX-x;
    float dy = mouseY-y;
    float r = sqrt(dx*dx+dy*dy);
    if (r<radius) {
    //fill (150,100);
    mouseOverMe=true;
    textSize(25);
    fill(200,0,0);
    text("\""+word+"\"",boxSizeX+100,boxSizeY/2);
    fill(255);
    textSize(15);
    if (count > 1 ) {
    text("appeared "+count+" times",boxSizeX+100,boxSizeY/2+20);
    }
    else {
    text("appeared "+count+" time",boxSizeX+100,boxSizeY/2+20);
    }
    //stroke(0);
    //line(x,y,boxSizeX+100,100);
    noStroke();
    fill(200,200,200,200);
    }
    else {
    int fillval=100+count*20;
    fill(fillval,100,100);
    mouseOverMe=false;
    }

    float displayDiam=2*radius;
    if (mouseOverMe==true && locked == true) {
    x=mouseX;
    y=mouseY;
    //displayDiam=3*radius;
    //cursor(HAND);
    }
    
    //ellipse(x+10, y+10, 2*radius, 2*radius);
    ellipse(x+10, y+10, displayDiam, displayDiam);
    //ellipse(30,30,30,30);
    //fill(0);
    //fill(100);
    fill(0,200);
    int tsize = (int) radius/2.;
    //textSize(tsize);
    textSize(12);
    if (mouseOverMe==true) {
    //textSize(30);
    //radius=boxSizeX/4;
    //x=mouseX;
    //y=mouseY;
    }
    float tw = textWidth(word);
    fill(255)
    text(word,x-tw/2.5,y+5,tw,radius*4);
  }

  // used to move the word bubbles
  void move() {
    vx=vx*myFriction;
    vy=vy*myFriction;
    vy+=gravity*radius*radius;
    x += vx;
    y += vy;
    if (x + radius > boxSizeX) {
      x = boxSizeX - radius;
      vx *= friction; 
    }
    else if (x - radius < 0) {
      x = radius;
      vx *= friction;
    }
    if (y + radius > boxSizeY) {
      y = boxSizeY - radius;
      vy *= friction; 
    } 
    else if (y - radius < 0) {
      y = radius;
      vy *= friction;
    }
  }

  // used to tell whether two word bubbles have collided
  void collide() {
    //Iterator i = hashwords.values().iterator();
    //while (i.hasNext()) {
    for (int i=0; i< numbuzzwords; i++) {
      
      //Word w = (Word) i.next();
      Word w = (Word) topwords.get(i);
      if (w.ID!=ID) {
      //Word w = (Word) topwords.get(i);
      float dx = w.x - x;
      float dy = w.y - y;
      float distance = sqrt(dx*dx + dy*dy);

      float minDist = w.radius + radius;

      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - w.x) * spring;
        float ay = (targetY - w.y) * spring;
        vx -= ax;
        vy -= ay;
        w.vx += ax;
        w.vy += ay;
     } // end if(distance < minDist) ...
    } // end if (w.word.equals(word) ...
    } // end while (i.hasNext())
  } // end void collide() ...
  

}

// need to have this class in order to compare whether two Word objects are the same word
class CompWord // : Comparator<A>
{
  int compare(Word x, Word y) {
    return y.count - x.count; // reverse order
  }
  bool equals(A x, A y) {
    return x.count === y.count; // reverse order
  }
}



int y,yinit;
int y2;
int ystep;
int xstart;


// below, in order to sort an ArrayList, uses methods in https://github.com/notmasteryet/processing-js/blob/71663044cbd6c78e80a3d908f705fc4736b8cb80/examples/libraries/collections-sort.html


ArrayList<String> words = new ArrayList(); // storing the words that come up in tweets
ArrayList topwords = new ArrayList();


float tweetHeight = height/1.3;

// the SETUP method is part of every visualization. this function is always run once at the beginning of the program.
void setup() {
size(window.innerWidth, window.innerHeight);

///////// this is the line that decides which hashtag to load tweets from:
loadTweets(searchTerm);
/////////


yinit=50;
y=yinit;
ystep=80;
y2=30;
xstart=boxSize+100;

textSize(22);

hashwords = new HashMap();
numbuzzwords=150;

boxSize=width/2;
boxSizeX=width/2;
boxSizeY=height/1.5;
//analyzeString(initializer);

fill(0);
rect(0,height/1.45,width,height);
tweetHeight=height/1.4;

} // end setup() ...

// the draw method is called continuously throughout the run of the program.
void draw () {

if (tweets.size() > 0) {

words.clear();
for (int i = 0; i < tweets.size(); i++) {
  Tweet t = (Tweet) tweets.get(i);
  String msg = t.text;
  String [] p = splitTokens(msg, " ,.?!:;&-)(|-~=");
  for (int j = 0; j < p.length; j++) {
    p[j]=trim(p[j]);
    words.add(p[j]);
  } // end for (int j = 0
  String fullTweet = join(p, " ");
  //textSize(20);

  //where the tweets on the right are displayed
  int xmax = width-30;
  fill(230);
  stroke();
  //rect(xstart,y,width,ystep*.95);
  fill(0);
  //text (fullTweet,xstart+10,y+ystep/2);
  text(fullTweet,boxSizeX+100,100);
  textSize(12);
  //text("-- "+t.date+" --\n"+msg,xstart+10,y+10,width/3,ystep);
  numTweetsAnalyzed++;
  y=y+ystep;
  if (y>(height-ystep)) {
  y = yinit;
}  


  //text(p[0], 30,y);
  //y=y+20;
  tweets.clear();
} // end for (int i = 0; i < tweets.size() ...

// now we have the words from the tweet in the "words" array.
// we will take each word from the words array as a string, "s", and if it is
// *not* one of the above "stopwords", we will add it to the hash table "hashwords" that contains all the words we want to keep.

if (words.size() > 0) {
for (int j=0; j< words.size(); j++) {
String s = words.get(j);

// make the word lowercase
s=s.toLowerCase();


// is the word "s" one of the stopwords? if so, make "isStopword" equal to 1
int isStopword = 0;
for (int k=0; k < stopwords.length; k++) {
String stopword = stopwords[k];
if (s.equals(stopword)==true) {
isStopword = 1;
} // end if (s.equals
} // end for(int k=0; k < stopwords ...

// check string length -- HACK
if (s.length()<4) {
isStopword=1;
}

// add the word "s" to the hash table if it is not a stopword
if (isStopword==0) {
if (hashwords.containsKey(s)) {
           //text(s,20,y);
	  Word w = (Word) hashwords.get(s);
          w.count=w.count+1;
          numTerms=numTerms+1;
} // end if (hashwords.contains ...
else {
          //text(s,width-30,y);
	  Word w = new Word(s);
          hashwords.put(s,w);
          //topwords.add(w);
          numTerms=numTerms+1;
} // end else ..
} // end if (isStopword==0 ...
} // end for (int j=0; j< words.size


} // end if (words.size() ...
} // end if (tweets.size() ...



// get the top N buzzwords
// copy the hashwords to the topwords
int wordcounter=0;
topwords.clear();
Iterator i = hashwords.values().iterator();
while (i.hasNext()) {
Word w = (Word) i.next();
w.ID=wordcounter;
wordcounter++;
topwords.add(w);
}


Collections.sort(topwords, new CompWord());
numbuzzwords=topwords.size();
if (topwords.size() > maxBuzzwords) {
numbuzzwords=maxBuzzwords;
}

// get the normalizing factor for the word counts
int topcount=0;
for (int i=0; i<numbuzzwords; i++) {
Word w = (Word) topwords.get(i);
topcount=topcount+w.count;
}

// display the buzzwords as bubbles on the screen
if (numbuzzwords>0) {
fill(0);
noStroke();
//rect(0,0,boxSizeX+100,boxSizeY+100);
rect(0,0,width,height/1.45);
for (int i = 0; i< numbuzzwords; i++) {
Word w = (Word) topwords.get(i);
w.radius=sqrt(((1/3.14159)*(float(w.count)/float(topcount))*areaFrac*boxSize*boxSize));
w.collide();
w.move();
//int tsize = (int) w.radius/2.;
//textSize(w.radius/1.2);
//fill(200,100);
fill(float(w.count)/float(topcount)*100+100);
//textSize((int) w.radius/2);
w.display();
//textSize((int) w.radius/2);
}
}

////// beginning of some extraneous display information on the screen (not related to the bubbles)
fill(200,100);
textSize(20);
String finalWord=" of the most recent tweets";
if (numTweetsAnalyzed == 1) {
	finalWord=" of the most recent tweets";
}

String msg = searchTerm + " Twitter stream";
fill(220,200);
textSize(20);
text(msg,boxSizeX+100,100);

fill(255);
noStroke();
msg = "top "+numbuzzwords+ " words in " + numTweetsAnalyzed + " of the most recent tweets";
fill(255);
textSize(18);
text(msg,boxSizeX+100,130);

fill(255);
textSize(15);
tweetHeight=tweetHeight+10;
if (tweetHeight>(height-20)) {
	tweetHeight=height/1.4;
}
text(fullTweet,10,tweetHeight);
fill(100,1);
rect(0,height/1.45,width,height);

//////////////// end of the extraneous display information



// reset the hash if it's too big:
if (hashwords.size() > 1000) {
hashwords.clear();
numTweetsAnalyzed=0;
}
} // end draw()



////////// some code allowing one to click on the bubbles and move them around
void mousePressed() {
if (locked==false) {
locked=true;
}
else {
locked=false;
}
}
void mouseReleased() {
locked=false;
}