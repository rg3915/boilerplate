

# Create requirements
mkdir requirements
touch requirements.txt 
touch requirements/{base,dev,prod}.txt

# Bootstrap templates
mkdir -p myproject/core/templates/core
touch myproject/core/templates/{base,index,nav,pagination}.html
touch myproject/core/templates/core/person_{detail,form,list}.html

echo "${green}>>> Creating static/css directory${reset}"
mkdir -p myproject/core/static/css

echo "${green}>>> Creating main.css${reset}"
cat << EOF > myproject/core/static/css/main.css
/* Sticky footer styles
-------------------------------------------------- */
/* http://getbootstrap.com/examples/sticky-footer-navbar/sticky-footer-navbar.css */
/* http://getbootstrap.com/2.3.2/examples/sticky-footer.html */
html {
  position: relative;
  min-height: 100%;
}
body {
  /* Margin bottom by footer height */
  margin-bottom: 60px;
}
#footer {
  position: absolute;
  bottom: 0;
  width: 100%;
  /* Set the fixed height of the footer here */
  height: 60px;
  background-color: #101010;
}
.credit {
  /* Center vertical text */
  margin: 20px 0;
}
/* Lastly, apply responsive CSS fixes as necessary */
@media (max-width: 767px) {
  body {
    margin-bottom: 120px;
  }

  #footer {
    height: 120px;
    padding-left: 5px;
    padding-right: 5px;
  }
}
/* My personal styles. */
.ok {
    color: #44AD41; /*verde*/
}

.no {
    color: #DE2121; /*vermelho*/
}
EOF

echo "${green}>>> Creating social.css${reset}"
cat << EOF > myproject/core/static/css/social.css
/* http://www.kodingmadesimple.com/2014/11/create-stylish-bootstrap-3-social-media-icons.html */
.social {
    margin: 0;
    padding: 0;
}

.social ul {
    margin: 0;
    padding: 5px;
}

.social ul li {
    margin: 5px;
    list-style: none outside none;
    display: inline-block;
}

.social i {
    width: 40px;
    height: 40px;
    color: #FFF;
    background-color: #909AA0;
    font-size: 22px;
    text-align:center;
    padding-top: 12px;
    border-radius: 50%;
    -moz-border-radius: 50%;
    -webkit-border-radius: 50%;
    -o-border-radius: 50%;
    transition: all ease 0.3s;
    -moz-transition: all ease 0.3s;
    -webkit-transition: all ease 0.3s;
    -o-transition: all ease 0.3s;
    -ms-transition: all ease 0.3s;
    text-decoration: none;
}

.social .fa-facebook {
    background: #4060A5;
}

.social .fa-twitter {
    background: #00ABE3;
}

.social .fa-google-plus {
    background: #e64522;
}

.social .fa-github {
    background: #343434;
}

.social .fa-pinterest {
    background: #cb2027;
}

.social .fa-linkedin {
    background: #0094BC;
}

.social .fa-flickr {
    background: #FF57AE;
}

.social .fa-instagram {
    background: #375989;
}

.social .fa-vimeo-square {
    background: #83DAEB;
}

.social .fa-stack-overflow {
    background: #FEA501;
}

.social .fa-dropbox {
    background: #017FE5;
}

.social .fa-tumblr {
    background: #3a5876;
}

.social .fa-dribbble {
    background: #F46899;
}

.social .fa-skype {
    background: #00C6FF;
}

.social .fa-stack-exchange {
    background: #4D86C9;
}

.social .fa-youtube {
    background: #FF1F25;
}

.social .fa-xing {
    background: #005C5E;
}

.social .fa-rss {
    background: #e88845;
}

.social .fa-foursquare {
    background: #09B9E0;
}

.social .fa-youtube-play {
    background: #DF192A;
}

.social .fa-slack {
    background: #4F3A4B;
}

.social .fa-whatsapp {
    background: #65BC54;
}

.socialfooter {
    margin: 0;
    padding: 0;
}

.socialfooter ul {
    margin: 0;
    padding: 5px;
}

.socialfooter ul li {
    margin: 5px;
    list-style: none outside none;
    display: inline-block;
}

.socialfooter i {
    color: #FFF;
    font-size: 22px;
    text-align:center;
    padding-top: 12px;
    border-radius: 50%;
    -moz-border-radius: 50%;
    -webkit-border-radius: 50%;
    -o-border-radius: 50%;
    transition: all ease 0.3s;
    -moz-transition: all ease 0.3s;
    -webkit-transition: all ease 0.3s;
    -o-transition: all ease 0.3s;
    -ms-transition: all ease 0.3s;
    text-decoration: none;
}

.socialfooter i:hover {
    color: #00ABE3;
}
EOF


pip install django dj-database-url django-bootstrap-form django-daterange-filter django-localflavor django-widget-tweaks python-decouple pytz selenium django-extensions

python manage.py makemigrations core
python manage.py migrate

# Tem que copiar os arquivos
cp fixtures/gen_address.py selenium/gen_address_.py
cp fixtures/gen_names.py selenium/gen_names_.py
cp fixtures/gen_random_values.py selenium/gen_random_values_.py
