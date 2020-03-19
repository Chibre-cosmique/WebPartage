#!/bin/bash

traitement () {
  
	for dossier in  `ls -d $l/*/ 2>/dev/null`
		do
			x=$(echo "${dossier//''$1'/Files/'}")
			x=`echo $x | sed 's/\///g'`

			nbImages=0
			nbVideo=0
			nbFichier=0

		    echo -e "\e[94m\nLe dossier $x à été trouvé\e[39m"

		    echo '<a href="Files/'$x'/'$x'.html"><button type="button">'$x'</button></a>'>> $sortie

		    sortieFichier="$1/Files/$x/$x.html"

		    rm $sortieFichier 2>/dev/null

		    echo '<!DOCTYPE html>
				<html>
				   <head>
				       <title>'$x'</title>
				       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				       <link rel="stylesheet" type="text/css" href="../../index.css">
				   </head>
				   <body>

				   <a href="../../index.html"><button type="button">Retour</button></a><br>' >> $sortieFichier
							      
		    for image in `ls $l/$x/*.PNG $l/$x/*.png $l/$x/*jpg 2>/dev/null`
			    do
			    	image=$(echo "${image//''$1'/Files/'$x''}")
		    		image=`echo $image | sed 's/\///g'`

			    	echo '<div id="conteneur">
			    			<a href="'$image'"><img id="miniatures" src="'$image'" alt="" /></a>
			    		</div>' >> $sortieFichier

			    	let "nbImages=nbImages+1"
			    	let "nbImagesT=nbImagesT+1"

			    done
				    
				if [ ! -e $1/Miniatures/$x ]
				then
				        mkdir $1/Miniatures/$x
				fi

			for video in `ls $l/$x/*.mp4 2>/dev/null`
				do

			        video=$(echo "${video//''$1'/Files/'$x''}")
		    		video=`echo $video | sed 's/\///g'`

					if [ ! -e $1/Miniatures/$x/$video'.png' ]
						then
					        ffmpeg -ss 00:00:05 -i $l/$x/$video -loglevel quiet -vf 'select=not(mod(n\,1)),tile=1x1' $1/Miniatures/$x/$video'.png' 
					        echo "$video.png a été créée"
					        
						fi
					echo '<div id="conteneur"> 
							<a href="'$video'"><img id="miniatures" src="'../../Miniatures/$x/$video'.png" alt="" />
								<img id="video-image" src="../../Icon/video.png" alt="" />
							</a>
						</div>' >> $sortieFichier

					let "nbVideo=nbVideo+1"
					let "nbVideoT=nbVideoT+1"
			done

			for file in `ls $l/$x/*.pdf $l/$x/*.xlsx $l/$x/*.docx $l/$x/*.pptx $l/$x/*.zip 2>/dev/null`
				do

					file=$(echo "${file//''$1'/Files/'$x''}")
		    		file=`echo $file | sed 's/\///g'`

					if grep -sq '.pdf' <<< "$file"
						then
							Icon="pdf.png"
						elif grep -sq '.zip' <<< "$file"
							then
								Icon="zip.png"
						elif grep -sq '.xlsx' <<< "$file"
							then
								Icon="xlsx.png"
						elif grep -sq '.docx' <<< "$file"
							then
								Icon="docx.png"

						elif grep -sq '.pptx' <<< "$file"
							then
								Icon="pptx.png"
					fi
					
					echo '<div id="conteneur">
							<a href="'$file'">
								<img id="miniatures" src="../../Icon/'$Icon'" alt="" />
								<p>'$file'</p>
							</a>
						</div>' >> $sortieFichier

					let "nbFichier=nbFichier+1"
					let "nbFichierT=nbFichierT+1"

			done

			echo '
			   </body>
			  </html>' >> $sortieFichier

			  echo "Images=$nbImages"
			  echo "Video=$nbVideo"
			  echo "Fichier=$nbFichier"

			echo -e "\e[92mLe dossier $x a été traité\e[39m"
		done

		echo -e "\nImages=$nbImagesT"
		echo "Video=$nbVideoT"
		echo -e "Fichier=$nbFichierT\n"
}

sortie=''$1'/index.html'
sortieCss=''$1'/index.css'
l=''$1'/Files'

rm $sortie 2>/dev/null

if [ ! -e $1/Miniatures ]
	then
		mkdir $1/Miniatures
	fi

echo '<!DOCTYPE html>
	<html>
	   	<head>
	       <title>PHOTOS</title>
	       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	       <link rel="stylesheet" type="text/css" href="index.css">
	   	</head>
	   	<body>
			<div>' >> $sortie

			traitement $1
		   		
	echo '</div>
	   	</body>
	</html>' >> $sortie

	echo 'body{

    font-family:Comic Sans, cursive;
	background-image:url(background.jpg);
	background-size: cover;
	background-repeat: no-repeat;
	background-attachment: fixed;
	text-decoration:none;
	display: inline-block;
}
  
#miniatures {

    padding: 20px;
    height: 200px;
	width: auto;
	border-radius: 25px;
}

#video-image{

    height: 20px;
	width: auto;
	position: absolute;
	left: 25px;
	top: 25px;

}

button {

	position:relative;
	background:#055388;
	border:1px solid white;
	padding:20px;
	font-size:0.9em;
	color:white;
	box-shadow:4px 4px 0px 0px white;
	font-family: 'Open Sans', sans-serif;
	font-weight:700;
	letter-spacing:5px;
	text-transform:uppercase;
	transition: all 100ms ease-in-out;
	left:0;
	top:0;
}

button:hover {

	left:4px;
	top:4px;
	box-shadow:0 0 0 0 white;
}

p{
	width: 240px;
	text-align: center;
	color: white;
	overflow: hidden;
  	text-overflow: ellipsis;
  	
}
a{
	text-decoration: none;

}

#conteneur{

	display: inline-block;
	position: relative;
}' > $sortieCss
