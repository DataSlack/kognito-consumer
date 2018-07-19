package br.com.kognito.consumer;

import java.io.InputStream;
import java.io.PrintStream;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Kognito Consumer Main Entrypoint
 */
public final class Consumer implements Runnable, AutoCloseable {

    private Orchestrator orchestrator;

    /**
     * Main Entrypoint.
     * @param args
     */
    public static void main(final String... args) {
        final String kcHome = System.getenv("KC_HOME");
        if (kcHome == null || kcHome.isEmpty()) {
            throw new IllegalStateException(
                    "KC_HOME environment variable must be set. This is likely a bug that should be reported."
            );
        }
        final Path home = Paths.get(kcHome).toAbsolutePath();
        try (
                final Consumer consumer = new Consumer(home, args, System.out, System.err, System.in)
        ) {
            consumer.run();
        } catch (final IllegalStateException e) {
            String errorMessage[] = null;
            if (e.getMessage().contains("Could not load FFI Provider")) {
                errorMessage = new String[]{
                        "\nError accessing temp directory: " + System.getProperty("java.io.tmpdir"),
                        "This often occurs because the temp directory has been mounted with NOEXEC or",
                        "the Logstash user has insufficient permissions on the directory. Possible",
                        "workarounds include setting the -Djava.io.tmpdir property in the jvm.options",
                        "file to an alternate directory or correcting the Logstash user's permissions."
                };
            }
            handleCriticalError(e, errorMessage);
        } catch (final Throwable t) {
            handleCriticalError(t, null);
        }
        System.exit(0);
    }


    private static void handleCriticalError(Throwable t, String[] errorMessage) {
        if (errorMessage != null) {
            for (String err : errorMessage) {
                System.err.println(err);
            }
        }
        System.exit(1);
    }

    /**
     * Ctor.
     * @param home Logstash Root Directory
     * @param args Commandline Arguments
     * @param output Output Stream Capturing StdOut
     * @param error Output Stream Capturing StdErr
     * @param input Input Stream Capturing StdIn
     */
    Consumer(final Path home, final String[] args, final PrintStream output,
             final PrintStream error, final InputStream input) {
        output.println("[KOGNITO-CONSUMER] Starting Kognito Consumer at " + home + "...");
        this.orchestrator = Orchestrator.build();
    }

    @Override
    public void close() throws Exception {
        this.orchestrator.shutdown();
    }

    @Override
    public void run() {
        this.orchestrator.start();
    }
}