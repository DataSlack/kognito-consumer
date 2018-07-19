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
    private PipelineInput input;
    private PipelineFilter filter;
    private PipelineOutput output;

    public PipelineConfiguration config() {
        return this.config;
    }

    public PipelineInput input() {
        return this.input;
    }

    public PipelineFilter filter() {
        return this.filter;
    }

    public PipelineOutput output() {
        return this.output;
    }
}
