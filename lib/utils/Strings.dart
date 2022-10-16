class AppText {
  // static String speechLanguage = "en-US";
  // static String speechLanguage = "ja-JP";
  static String speechLanguage = "id-ID";

  //static String swipeUpConfirm = "are you sure you answered correctly? if yes, please swipe up again";
  static String swipeUpConfirm = "Apakah kamu yakin menjawab benar? jika ya, swipe atas lagi";
  //static String swipeDownConfirm = "did you answer wrong? swipe down again to confirm";
  static String swipeDownConfirm = "Apakah kamu yakin menjawab salah? swipe bawah lagi untuk konfirmasi";
  //static String swipeDownFinal = "please wait, we will provide material recommendations";
  static String swipeDownFinal = "Mohon tunggu, aku akan merekomendasikan materi untuk kamu";

  // static String overlaySwipeUp = "Swipe up to answer correctly";
  // static String overlaySwipeDown = "Swipe down to answer wrong";
  // static String overlaySwipeLeft = "Swipe left to repeat speech";
  // static String overlaySwipeRight = "Swipe right to scan";

  static String overlaySwipeUp = "Swipe atas jika jawaban benar";
  static String overlaySwipeDown = "Swipe bawah jika jawaban salah";
  static String overlaySwipeLeft = "Swipe kiri untuk mengulang suara";
  static String overlaySwipeRight = "Swipe kanan untuk membaca materi berikutnya";
}

class SpeechText {

  static String result(String detectedClass) {
    // return "This is pattern " + detectedClass;
    return "Ini adalah pola " + detectedClass;
  }

  static String detectedClassCondition0 = "Ada 3 braille full";
  static String detectedClassCondition1 = "Ada 4 braile. Urutannya adalah braille full, braile A, braile full dan braile A";
  static String detectedClassCondition2 = "Ada 4 braile. Braile full, braile B, braile full dan braile B";
  static String detectedClassCondition3 = "Ada 4 braile. Braile full, braile titik nomor 3, braile full dan braile titik nomor 3.";
  static String detectedClassCondition4 = "Ada 4 braile. Braile full, braile L, braile full, dan braile L";
  static String detectedClassCondition5 = "Ada 4 braile. Braile full, braile K, braile full dan braile K";
  static String detectedClassCondition6 = "Ada 4 braile. Braile full, braile C, braile full dan braile C";
  static String detectedClassCondition7 = "Ada 4 braile. Braile full, braile F, braile full dan braile F";
  static String detectedClassCondition8 = "Ada 4 braile. Braile full, braile P, braile full dan braile P";
  static String detectedClassCondition9 = "Ada 4 braile. Braile full, braile I, braile full dan braile I";
  static String detectedClassCondition10 = "Ada 4 braile. Braile lajur kiri, braile M, braile lajur kiri dan braile M";
  static String detectedClassCondition11 = "Ada 4 braile. Braile lajur kiri, braile S, braile lajur kiri dan braile S";
  static String detectedClassDefaultCondition = "Maaf, belum terdeteksi";

  static String home2shake(){
    //return "Now you are in the home page. Please hover the phone on the flashcard so I can read it for you.";
    return "Sekarang kamu ada di halaman utama. Arahkan kamera ke flashcard agar aku bisa membacakan braille untuk kamu";
  }

  static String home4shake(String name){
    /*return """
    Welcome! I am Tenji. Nice to meet you $name! 

We will learn together in how to read braille by using this app and the flashcard. Make sure to have the flashcard with you so I can read the flashcard for you.

Thanks! Remember, you can call me again by just shaking the phone twice.

There are two pages in this app, home and result page. In the home page, you can scan the braille written on the flash card by hovering the phone’s camera on the flashcard, so I can read it for you to let you know whether you are correct or not in reading. In the home page, you can hear this tutorial again by just shaking the phone 4 times or more.

Now, you can try to open the first page of the flashcard and hover the phone on it so I can read it for you!

Enjoy the reading!
    """;*/
    
    return """
    
    Selamat datang! Perkenalkan aku Tenji. Salam kenal $name!
    
    Kita akan belajar bersama untuk membaca braille dengan menggunakan aplikasi ini dan flashcard. Pastikan kamu sudah memliki flashcard yang nantinya akan aku bacakan.

Ingat, kamu dapat memanggilku lagi dengan cara mengocok hp ini.

Jadi di aplikasi ini ada 2 halaman. Halaman utama dan halaman hasil. Di halaman utama, kamu dapat melakukan scan ke braille yang tertulis di flashcard dengan cara mengarahkan kamera hp ke flashcard, sehingga aku bisa membacakan apa yang tertulis di sana. Dengan begitu, kamu akan tahu bahwa sudah membaca braille dengan benar atau belum.

Oh iya, kamu bisa mendengar tutorial ini lagi jika kamu menekan layer lama di halaman utama.

Sekarang, coba kamu arahkan kamera kea rah flashcard, aku akan mencoba membacakan brailenya.

Selamat mencoba!

    
    """;
  }

  static String result2shake(String name){
    /*return """
    Hi $name, now you are in the result page. 

As you have just touch, braille has 6 dots. 3 dots on the left and 3 others on the right side. It’s difficult to feel them, right?
But trust me, you are going to be an expert if you keep practicing!
Just tips, reading braille with your both left and right index finger will help a lot!
Other tips, by reading them horizontally, you will understand the pattern more!
Enjoy!
    """;*/
    
    return """
      
      Halo $name, sekarang kamu di halaman hasil.

Seperti yang baru saja kamu sentuh, 1 braile memiliki 6 titik, 3 titik di kiri dan 3 titik di kanan. Agak sulit untuk memahaminya ya?
Tapi yakinlah, jika kamu terus berlatih, kamu akan menjadi mahir dengan sendirinya.
Sekedar tips, membaca braille dengan jari telunjuk tangan kiri dan kanan akan sangat membantu. Tips lain yaitu cobalah membaca secara horizontal, kamu akan lebih memahami bentuk braille dengan lebih cepat.

Selamat mencoba!

      
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
    /*return """
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
    """;*/
    
    return """
    Halo $name, sekarang kamu ada di halaman hasil. 

Seperti yang baru saja kamu baca, full braille mempunyai 6 titik, tiga titik di bagian kiri dan 3 titik di bagian kanan.

Di halaman ini, ada 3 full braille.

Kita menghitung titik di braille dari kiri atas ke kanan bawah, yaitu titik 1,2,3 di kiri dan 4,5,6 di kanan. 

Agak sulit bukan?
Tapi percayalah, kamu akan mahir membaca jika kamu tetap berlatih.

Sekedar tips, membaca braille dengan jari telunjuk tangan kiri dan kanan akan sangat membantu. Tips lain yaitu cobalah membaca secara horizontal, kamu akan lebih memahami bentuk braille dengan lebih cepat.

Selamat mencoba!

    
    
    """;
  }

  static String resultShakeClass1(String name) {
    /*return """
    Hi $name,
The full braille helps you in recognizing the next
brille which is an A braille.
Braille A has a dot position at number 1.
Try to move your index finger horizontally to
compare the dot 1 position with the full braille. Do
not move in vertically.
Take your time!
    """;*/
    
    return """
    
    Halo $name,

Braile full membantu kamu untuk membaca braile A di sebelahnya.

Braile A memiliki titik nomor 1.

Cobalah untuk menggerakkan telunjuk kamu secara mendatar untuk mengetahui lokasi dot nomor 1 dari braille full tersebut.
Jangan digerakkan naik-turun yaa

Selamat mencoba

    
    """;
    
  }

  static String resultShakeClass2(String name) {
    /*return """
    Hi $name,
Braille B has dots position at number 1 and 2.
    """;*/
    
    return """
    
    Halo $name,

Braile B memiliki titik pada nomor 1 dan 2.

    
    """;
  }

  static String resultShakeClass3(String name) {
    /*return """
    Hi $name,
There is no alphabet which has only dot number 3.
But this will help you in learning the next alphabet.
It’s getting fun right!
    """;*/
    
    return """
    
    Halo $name

Sebenarnya tidak ada huruf dengan titik nomor 3 saja, tetapi ini akan membantu kamu dalam belajar karakter selanjutnya.

Semakin menarik bukan!

    
    """;
  }

  static String resultShakeClass4(String name) {
    /*return """
    Hi $name,
L braille has dots number 1, 2 and 3. Those dot
makes a left line of a braille
    """;*/
    
    return """
    
    Halo $name,

Braile L memiliki titik nomor 1, 2 dan 3. Ketiga titik tersebut menjadikan satu baris titik sebelah kiri.

Karena satu braile memiliki 6 titik, kamu dapat mengingat ada satu lajur kiri dan satu lajur kanan. Braile L adalah lajur kiri.

Semangat belajarnya yaa

    
    """;
  }
  
  static String resultShakeClass5(String name) {
        
    return """
    
    Halo $name,
    
    Braile K memiliki titik nomor 1 dan 3.
    
    """;
  }
  
  static String resultShakeClass6(String name) {
        
    return """
    
    Halo $name,
    
    Braile C memiliki titik nomor 1 dan 4.

Apa kamu bisa merasakannya? Cobalah berulangkali

    
    """;
  }
  
  static String resultShakeClass7(String name) {
        
    return """
    
    Halo $name,
    
    Braile F memiliki titik nomor 1, 2 dan 4. Jika hanya ada titik nomor 1 dan 2, maka itu adalah braile B. 

Apakah kamu masih ingat?

    
    """;
  }
  
  static String resultShakeClass8(String name) {
        
    return """
    
    Halo $name,
    
    Braile P memiliki titik nomor 1, 2, 3 dan 4, atau bisa aku sebut lajur kiri dan titik nomor 4.
    
    """;
  }
  
  static String resultShakeClass9(String name) {
        
    return """
    
    Halo $name,
    
    Braile I memiliki titik nomor 2 dan 4. Coba rasakan perbedaanya dengan braile F yang memiliki titik nomor 1, 2 dan 4.
    
    """;
  }
  
  static String resultShakeClass10(String name) {
        
    return """
    
    Halo $name,
    
    Ingat, lajur kiri berarti titik 1, 2 dan 3. Mulai dari halaman ini, braile pembantu bukan lagi braile full, melainkan braile lajur kiri.

Braile M memiliki titik nomor 1, 3 dan 4.

    
    """;
  }
  
  static String resultShakeClass11(String name) {
        
    return """
    
    Halo $name,
    
    Braile S memiliki titik nomor 2, 3 dan 4.

Selamat! Kamu sudah menguasai 10 braile dasar! Semangat belajarnya!

    
    """;
  }
  
}
