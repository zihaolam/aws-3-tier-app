export interface NodeStats {
    private_ip: string;
    utilization: {
        cpu: number;
        memory: number
    }   
}