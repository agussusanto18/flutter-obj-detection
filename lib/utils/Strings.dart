class AppText {
  static String swipeUpConfirm = "are you sure you answered correctly? if yes, please swipe up again";
  static String swipeDownConfirm = "did you answer wrong? swipe down again to confirm";
  static String swipeDownFinal = "please wait, we will provide material recommendations";
}

class SpeechText {

  static String home2shake(){
    return "Now you are in the home page. Please hover the phone on the flashcard so I can read it for you.";
  }

  static String home4shake(String name){
    return """
    Welcome! I am Tenji. Nice to meet you $name! 

We will learn together in how to read braille by using this app and the flashcard. Make sure to have the flashcard with you so I can read the flashcard for you.

Thanks! Remember, you can call me again by just shaking the phone twice.

There are two pages in this app, home and result page. In the home page, you can scan the braille written on the flash card by hovering the phone’s camera on the flashcard, so I can read it for you to let you know whether you are correct or not in reading. In the home page, you can hear this tutorial again by just shaking the phone 4 times or more.

Now, you can try to open the first page of the flashcard and hover the phone on it so I can read it for you!

Enjoy the reading!
    """;
  }

  static String result2shake(String name){
    return """
    Hi $name, now you are in the result page. 

As you have just touch, braille has 6 dots. 3 dots on the left and 3 others on the right side. It’s difficult to feel them, right?
But trust me, you are going to be an expert if you keep practicing!
Just tips, reading braille with your both left and right index finger will help a lot!
Other tips, by reading them horizontally, you will understand the pattern more!
Enjoy!
    """;
  }

  static String result4shake(String name){
    return """
    Hi $name, now you are in the Result page. 

I will read the braille for you in this page like I’ve just done. And you can let me know whether you are correct or wrong so that I can recommend you the suitable material to learn. It is fun right? 

Swipe up the screen if you are correct in reading braille, swipe down if you are incorrect, swipe left if you want me to say the braille again, and swipe right to go to the home page and scan more materials. 

In this page, you can shake the phone 4 times or more to hear the tutorial again or shake 2 times to hear the explanation about the related learning material.

Please try those gestures! See you!
    """;
  }

  static String resultShakeClass0(String name){
    return """
    Hi $name, now you are in the result page.
As you have just touch, a full braille has 6 dots. 3
dots on the left and 3 others on the right side.
Tn this page, there are 3 of them.
We count the dots from the up-left to the bottomleft as 1, 2, 3 dot and from the up-right to the
bottom-right as 4, 5, 6 dot.
It’s difficult to feel them, right?
But trust me, you are going to be an expert if you
keep practicing!
Just tips, reading braille with your both left and
right index finger will help a lot!
Other tips, by reading them horizontally, you will
understand the pattern more!
Enjoy!
    """;
  }

  static String resultShakeClass1(String name) {
    return """
    Hi $name,
The full braille helps you in recognizing the next
brille which is an A braille.
Braille A has a dot position at number 1.
Try to move your index finger horizontally to
compare the dot 1 position with the full braille. Do
not move in vertically.
Take your time!
    """;
  }

  static String resultShakeClass2(String name) {
    return """
    Hi $name,
Braille B has dots position at number 1 and 2.
    """;
  }

  static String resultShakeClass3(String name) {
    return """
    Hi $name,
There is no alphabet which has only dot number 3.
But this will help you in learning the next alphabet.
It’s getting fun right!
    """;
  }

  static String resultShakeClass4(String name) {
    return """
    Hi $name,
L braille has dots number 1, 2 and 3. Those dot
makes a left line of a braille
    """;
  }
}