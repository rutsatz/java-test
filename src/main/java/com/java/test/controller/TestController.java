package com.java.test.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalTime;

@RestController
@RequestMapping("/")
public class TestController {

    @GetMapping
    public String hello() {
        return "<p>v32</p>" +
                "Hello! Time now is " + LocalTime.now();
    }

}
