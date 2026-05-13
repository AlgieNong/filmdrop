package com.filmdrop.web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.filmdrop")
public class FilmDropApplication {

    public static void main(String[] args) {
        SpringApplication.run(FilmDropApplication.class, args);
    }
}
