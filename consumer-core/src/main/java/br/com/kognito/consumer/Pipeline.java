package br.com.kognito.consumer;

import br.com.kognito.consumer.pipeline.PipelineConfiguration;
import br.com.kognito.consumer.pipeline.PipelineFilter;
import br.com.kognito.consumer.pipeline.PipelineInput;
import br.com.kognito.consumer.pipeline.PipelineOutput;

/**
 * Pipeline Class
 */
public class Pipeline {

    /**
     * Current Pipeline Configuration
     */
    private PipelineConfiguration config;

    /**
     * Get current pipeline configuration
     * @return
     */
    public PipelineConfiguration config() {
        return this.config;
    }
}
