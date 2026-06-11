package com.tx.common.file;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import org.apache.sanselan.ImageReadException;

public interface CMYKConverter{
 
 
    public BufferedImage readImage(File file) throws IOException, ImageReadException;
 
    public void checkAdobeMarker(File file) throws IOException, ImageReadException;
    
   
     
}