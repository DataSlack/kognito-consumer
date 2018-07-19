package br.com.kognito.consumer;

import br.com.kognito.consumer.pipeline.PipelineConfiguration;
import br.com.kognito.consumer.pipeline.PipelineFilter;
import br.com.kognito.consumer.pipeline.PipelineInput;
import br.com.kognito.consumer.pipeline.PipelineOutput;

/**
 * Pipeline Class
 */
public class Pipeline {

    private PipelineConfiguration config;


    public PipelineConfiguration config() {
        return this.config;
    }
}
