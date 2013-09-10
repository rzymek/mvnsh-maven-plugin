package org.github.rzymek.maven

import java.io.BufferedReader
import java.io.InputStreamReader
import org.apache.commons.io.IOUtils
import org.apache.maven.Maven
import org.apache.maven.execution.DefaultMavenExecutionRequest
import org.apache.maven.execution.MavenSession
import org.apache.maven.plugin.AbstractMojo
import org.apache.maven.plugin.MojoExecutionException
import org.apache.maven.plugin.MojoFailureException
import org.apache.maven.plugins.annotations.Component
import org.apache.maven.plugins.annotations.Mojo
import org.apache.maven.plugins.annotations.Parameter
import org.apache.maven.plugins.annotations.ResolutionScope
import org.apache.maven.profiles.DefaultProfileManager

@Mojo(name='run', requiresDependencyResolution=ResolutionScope::COMPILE_PLUS_RUNTIME)
class mvnsh extends AbstractMojo {
	@Parameter(defaultValue='${session}', required=true, readonly=true)
	MavenSession session
	@Parameter(defaultValue='${basedir}', required=true, readonly=true)
	String baseDir
	@Component
	Maven maven
	@Parameter(defaultValue='${mvn}')
	String goals
	@Parameter(defaultValue='${sh}')
	String sh

	override execute() throws MojoExecutionException, MojoFailureException {
		val reader = new BufferedReader(new InputStreamReader(System.in))
		while (true) {
			log.info("Press ENTER  to run: " + goals + "; " + (sh ?: ''));
			if (reader.readLine == null) {
				return;
			}
			try {
				if (goals != null) {
					val showErrors = false
					val request = new DefaultMavenExecutionRequest(
						session.localRepository,
						session.settings,
						session.eventDispatcher,
						goals.split('[ ,]').map[trim],
						baseDir,
						new DefaultProfileManager(session.container, session.executionProperties),
						session.executionProperties,
						session.userProperties,
						showErrors
					)
					maven.execute(request)
				}
				if (sh != null) {
					val builder = new ProcessBuilder(sh)
					builder.redirectErrorStream = true
					val process = builder.start
					IOUtils.copy(process.inputStream, System.out);
				}
			} catch (Exception ex) {
				log.error("Build error:" + ex);
			}
		}
		log.info("Exiting...")
	}
}
