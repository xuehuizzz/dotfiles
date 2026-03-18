package com.xh.scheduler;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;


@Component
@EnableScheduling
public class StackScheduler {

    // 程序执行结束后, 每隔 2 分钟后再次执行
    @Scheduled(initialDelay = 0, fixedDelay = 2, timeUnit = TimeUnit.MINUTES)
    public void getStockRss() throws Exception {
        System.out.println("测试: " + LocalDateTime.now());
    }
}
