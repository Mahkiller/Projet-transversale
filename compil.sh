echo "Compilation des fichiers Java..."

cd src

javac -cp /opt/tom-cat/lib/servlet-api.jar:../WEB-INF/lib/postgresql-42.7.8.jar:. *.java -d ../WEB-INF/classes

if [ $? -eq 0 ]; then
    echo "Compilation réussie!"
else
    echo "Erreur lors de la compilation!"
    exit 1
fi