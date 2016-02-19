function mvnc() {
  `brew --prefix`/bin/mvn $@ | sed -e "s/\[INFO\]\(\ \-.*\)/[INFO]$fg[cyan]\1$reset_color/g" \
                              -e "s/\[INFO\]\(\ >>> .*\)/[INFO]$fg[cyan]\1$reset_color/g" \
                              -e "s/\[INFO\]\(\ <<< .*\)/[INFO]$fg[cyan]\1$reset_color/g" \
                              -e "s/\[INFO\]\(\ Building .*\)/[INFO]$fg[cyan]\1$reset_color/g" \
                              -e "s/\[INFO\]\(\ BUILD SUCCESS\)/[INFO]$fg[green]\1$reset_color/g" \
                              -e "s/\[INFO\]\(\ BUILD FAILURE\)/[INFO]$fg[red]\1$reset_color/g" \
                              -e "s/\(\[WARNING\].*\)/$fg[yellow]\1$reset_color/g" \
                              -e "s/\(\[ERROR\].*\)/$fg[red]\1$reset_color/g" \
                              -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\), Time elapsed: \([^ ]*\) sec/$fg[green]Tests run: \1$reset_color, $fg[yellow]Failures: \2$reset_color, $fg[red]Errors: \3$reset_color, $fg[magenta]Skipped: \4$reset_color, $fg[cyan]Time elapsed: \5 sec$reset_color/g" \
                              -e "s/\(<<< FAILURE\!\)/$fg[red]\1$reset_color/g"
}

function mvns() {
  local settings=$HOME/.m2/settings-$1.xml
  if [ $# -ne 1 ];then
    echo "$fg[cyan]Usage: mvns <settings-name>$reset_color"
    return 1
  elif [ ! -f $settings ];then
    echo "$fg[red]no such file: $settings$reset_color"
    return 1
  fi
  ln -sf $settings $HOME/.m2/settings.xml
  echo "$fg[cyan]settigns.xml changed to $fg[green]settings-$1.xml$reset_color"
}

alias mvn="mvnc"

# goal completions
function listMavenCompletions { reply=(archetype:generate compile clean eclipse:clean eclipse:eclipse install test deploy package jetty:run -DskipTests -Dtest= `if [ -d ./src ] ; then find ./src -type f | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`); }
compctl -K listMavenCompletions mvn mvnd mvn3

export MAVEN_OPTS=-Xmx1024m
