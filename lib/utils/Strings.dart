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
}