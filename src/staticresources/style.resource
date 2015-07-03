/* http://meyerweb.com/eric/tools/css/reset/ 
   v2.0 | 20110126
   License: none (public domain)
*/
html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed,
figure, figcaption, footer, header, hgroup,
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
  margin: 0;
  padding: 0;
  border: 0;
  font-size: 100%;
  font: inherit;
  vertical-align: baseline; }

/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
  display: block; }

body {
  line-height: 1; }

ol, ul {
  list-style: none; }

blockquote, q {
  quotes: none; }

blockquote:before, blockquote:after,
q:before, q:after {
  content: '';
  content: none; }

table {
  border-collapse: collapse;
  border-spacing: 0; }


.b12-radio-container {
	width: 500px;
	background: #000;
	height: 1%;
	overflow: hidden;
	clear: both;
}
.b12-radio-center {
	width: 320px;
	margin: 10px 0 0 0;	
	float: left;
}
.b12-radio-screen {
	background-color: #fff;
	width: 300px;
	height: 40px;
	padding: 0 10px;
	border-radius: 3px;
}
.b12-radio-screen-station {
	font-family: monospace;
	line-height: 40px;
	text-transform: uppercase;
	font-size: 32px;
	float: left;
}
.b12-radio-screen-vol {
	float: right;
	font-family: monospace;
	text-transform: uppercase;
	padding-top: 5px;
}
.b12-radio-buttons {
	margin-top: 10px;
}
.b12-radio-buttons ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	margin-left: 8px;
}
.b12-radio-buttons ul li {
	display: inline-block;
	margin: 0px;
}
.b12-radio-buttons a {
	display: block;
	font-family: monospace;
	background: #fff;
	width: 30px;
	margin-right: 4px;
	text-decoration: none;
	padding: 3px 0;
	text-align: center;
	border-right: solid 1px #747788;
	border-bottom: solid 1px #747788;
}
.b12-radio-buttons a.selected {
	box-shadow: 2px 2px 3px #747788 inset;
}


.b12-dial {
	padding: 20px;
	float: left;
}
.b12-dial b {
	display: block;
	width: 100%;
	font-weight: normal;
}
.b12-dial .inner {
	margin: 0 auto;
	position: relative;
}
.b12-dial .dial.inner {
	width: 50px;
	height: 50px;
}
.b12-dial .dial .shadow {
	position: absolute;
	width: 100%;
	height: 100%;
	border-radius: 50%;
}
.b12-dial .dial .shadow-out {
	margin: -9% 0 0 -9%;
	padding: 9%;
	box-shadow: 0px 4px 30px #747788;
	background: #fff;
	background: -webkit-linear-gradient(-90deg, #fff, #eaebed);
	background: -moz-linear-gradient(-90deg, #fff, #eaebed);
	background: -ms-linear-gradient(-90deg, #fff, #eaebed);
	background: -o-linear-gradient(-90deg, #fff, #eaebed);
	background: linear-gradient(-90deg, #fff, #eaebed);
}
.b12-dial .dial .shadow-in {
	margin: -4% 0 0 -4%;
	padding: 4%;
	box-shadow: 0px 3px 10px #747788 inset;
	background: #fff;
	background: -webkit-linear-gradient(-90deg, #fff, #dce1e7);
	background: -moz-linear-gradient(-90deg, #fff, #dce1e7);
	background: -ms-linear-gradient(-90deg, #fff, #dce1e7);
	background: -o-linear-gradient(-90deg, #fff, #dce1e7);
	background: linear-gradient(-90deg, #fff, #dce1e7);
}
.b12-dial .label {
	position: absolute;
	display: block;
	width: 50px;
	font-family: monospace;
	font-size: 32px;
	z-index: 10;
	text-align: center;
	line-height: 50px;
	cursor: pointer;
}
