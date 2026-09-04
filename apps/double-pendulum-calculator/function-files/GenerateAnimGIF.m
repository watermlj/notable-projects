function anim = GenerateAnimGIF(length1, length2, theta1, ...
    theta2, massColor1, massColor2, numFrames, timeFinal)

    filename = string(input("GIF filename: ", "s"));
    anim = struct('cdata', [], 'colormap', []);

    for i = 1:numFrames

        anim(i) = GenerateFrame(length1, length2, theta1, theta2, ...
            massColor1, massColor2, i);

        [indexedImage, colorMap] = rgb2ind(anim(i).cdata, 256);

        if i == 1

            imwrite(indexedImage, colorMap, filename, 'gif', ...
                'LoopCount', inf, 'DelayTime', timeFinal / numFrames);

        else

            imwrite(indexedImage, colorMap, filename, 'gif', ...
                'WriteMode', 'append', 'DelayTime', timeFinal / numFrames);

        end

    end

end