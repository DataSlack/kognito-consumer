package br.com.kognito.consumer.pipeline;

/**
 * Pipeline Configuration
 */
public class PipelineConfiguration {

    /**
     * Input Plugin
     */
    private PipelineInput input;

    /**
     * Filter Plugin
     */
    private PipelineFilter filter;

    /**
     * Output Plugin
     */
    private PipelineOutput output;

    /**
     * Get current PipelineInput
     * @return
     */
    public PipelineInput input() {
        return this.input;
    }

    /**
     * Get current PipelineFilter
     * @return
     */
    public PipelineFilter filter() {
        return this.filter;
    }

    /**
     * Get current PipelineOutput
     * @return
     */
    public PipelineOutput output() {
        return this.output;
    }

    /**
     * Reload current configuration from config files
     */
    public void reload() {

    }
}
