mvnsh-maven-plugin
==================

### Usage


**1.** Add the plugin repository to your pom:

	<project>
		<pluginRepositories>
			<pluginRepository>
				<id>rzymek-snapshots</id>
				<url>https://github.com/rzymek/repository/raw/master/snapshots</url>		
			</pluginRepository>
		</pluginRepositories>
		...
		
**2.** Run it:

    mvn mvnsh:mvnsh-maven-plugin:run -Dmvn="clean install"
or

    mvn mvnsh:mvnsh-maven-plugin:run -Dmvn=clean,install
To execute a shell command after succefull build add `-Dsh=`
    
    mvn mvnsh:mvnsh-maven-plugin:run -Dmvn=install -Dsh="mv target/*.war $AS/deploy"
