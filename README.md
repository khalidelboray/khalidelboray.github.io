# Web Scraping With perl/python `[Part 1]`


### بسم الله الرحمن الرحيم

باذن الله هنتكلم عن ال Web Scraping و الحاجات المتعلقه بيه 
اول حاجه هنوضح الحاجات اللي لازم تبقي عارفها قبل ما نكمل كلام 
وياريت تمشي عليهم بالترتيب ومتفوتش حاجه منغير 30% فهم ع الاقل 
وهي   


#### 1. معرفه عامه بال HTML و  CSS وغهم خاص ل ال HTML DOM   

* <a href="https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction" target="_blank">Introduction to the DOM</a>
* <a href="https://developer.mozilla.org/en-US/docs/Web/API/Document_object_model/Locating_DOM_elements_using_selectors" target="_blank">Locating DOM elements using selectors</a>
* <a href="https://developer.mozilla.org/en-US/docs/Web/API/Document_object_model/How_to_create_a_DOM_tree" target="_blank">How to create a DOM tree</a>


> **take a break**

<hr>

#### 2. أساسيات لغه برمجه بتتعامل مع الويب  (python/perl/ruby/go etc..)
* التعامل مع النوصوص وال Data structures المختلفه 
*   IO Operations / تقرا  Input من اليوزر وتعمل Output لمختلف ال Output streams 

#### 3. فهم عام ل الويب بمفهوماته بم انا كل تعاملنا معاه وخصوصا ال HTTP  

* <a href="https://www2.cs.sfu.ca/CourseCentral/165/common/study-guide/content/www-internet.html" target="_blank">The Internet</a>
* <a href="https://www2.cs.sfu.ca/CourseCentral/165/common/study-guide/content/www-protocols.html" target="_blank">Internet Protocols</a>
* <a href="https://www2.cs.sfu.ca/CourseCentral/165/common/study-guide/content/www-http.html" target="_blank">The Web and HTTP</a>
* <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP" target="_blank">HTTP Basics (MDN)</a>

> **take a break**
<hr>



#### 4. شويه مهارات لازم تبقا عارفها عموما 


* File and Directory Access
* Regex (  Regular expressions  ) and pattern matching   


تقدر تتعلم Regex من هنا ولو حاجه من الاساله دي وقفت عليك او مش فاهمها كلمني 
 
 
 
* <a href="https://regexone.com/" target="_blank">regexone.com</a>
* <a href="http://play.inginf.units.it/#/" target="_blank">play.inginf.units.it</a>
* <a href="https://github.com/ziishaned/learn-regex" target="_blank">https://github.com/ziishaned/learn-regex</a>   



هيعلموك Regex   وفي نفس الوقت هتطبق علي امثله كويسه 
 
> **take a break**

<hr>   

طيب لغايه دلوقتي لو انت مشيت مع اللي انا طلبته منك هتبقي جاهز نبدا سوا 
مبدايا كدا طالما احنا هنتكلم عن ال Web Scraping   
يبقي لازم هنتعامل مع ال Web / HTTP   
وعشان احنا هنتعامل مع  Website/Web Server   
يبقي لازم نتعامل من خلال Web Client   
في الطبيعي ال Client ده بيبقي المتصفح بتاعك ، هو اللي بيبعت Request وهو اللي بيستقبل ال Response ويتعامل معاها 
زي ما انت فهمت في الينكات اللي فوق 
طيب دلوقتي احنا هنتعامل من خلال لغات برمجه ، يعني بعيد عن المتصفح حتي الان ، في لغات البرمجه هنتعامل ب   
HTTP Client   
هيختلف حسب لغه البرمجه وحسب احتياجاتك   
احنا هنتعامل ببايثون وبيرل ف  هوضح الحتمالات المتاحه في الاتنين علي حد علمي وهوضح هنستخدم ايه   


<table>
<thead>
	<tr>
		<th>Perl</th>
		<th>Python</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td><a href="https://metacpan.org/pod/LWP::UserAgent" target="_blank">LWP::UserAgent</a></td>
		<td><a href="https://requests.readthedocs.io/en/master/" target="_blank">requests</a></td>
	</tr>
		<tr>
		<td><a href="https://metacpan.org/pod/Mojo::UserAgent" target="_blank">Mojo::UserAgent</a></td>
		<td><a href="https://docs.aiohttp.org/en/stable/" target="_blank">aiohttp</a></td>
	</tr>
</tbody>
</table>


طريقه التعامل مع كل كلاينت من دول هتبقي متشابه لانهم بيعملوا نفس الوظيفه 
باختلاف مميزات كل واحد عن التاني طبعا   
بالنسبه لبيرل هستخدم Mojo::UserAgent   
والسبب هوضحه بعديتن 
بالنسبه لبايثون هستخدم requests لانها متداوله واغلبكوا عارفها 

طيب ناخد مثال سريع ل استخدام الاتنين   
الاول 

> Perl
> ```perl
> use strict;
> use warnings;
> use 5.10.0;
> use Mojo::UserAgent;
> 
> my $ua  = Mojo::UserAgent->new;
> my $res = $ua->get('mojolicious.org/perldoc')->result;
> if($res->is_success){ 
>     say $res->body 
> }elsif($res->is_error){ 
>     say $res->message 
> }else{
>     say "Have no idea";
> }
> ```



  
> Python
> ```python
> # import the module
> import requests
> 
> try:
>     # send a GET request with the `get` func
>     resp = requests.get('https://httpbin.org/get')  
>     # Raise Errors
>     resp.raise_for_status()
>     # Print error if there is one
> except requests.exceptions.HTTPError as err:
>     print(err)
> #if not print response content
> print(resp.content)
> ```


نوع الايرور اللي بنهاندله هنا بيجي بعد ما بنبعت الريكويست 
في ايرور تاني ممكن يخلي الكود بتاعك يجيب runtime error مثلا 
وهو ال connection error 
وده ممكن يحصل لما النت يكون فاصل عندك او الدومين غلط او غيره من الاسباب وفي الحاله دي الريكويست مش هيتبعت اصلا<br>
طيب لغايه دلوقتي انت عملت زي ما المتصفج بيعمل لما تكتب URL وتضغط انتر 
بعد كدا لازم نتعامل مع ال HTML اللي جالك ده 
هنعتبره دلوقتي HTML بس لغايه ما يقابلنا كلام تاني قدام

مثال علي HTML هنشتغل عليه 
```html
<!DOCTYPE html>  
<html>  
    <head>
    </head>
    <body>
        <h1> Header tag </h1>
        <p> p tag </p>
    <body>
</html>
```
