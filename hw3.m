%影像讀取
img = imread('abc.png');
figure(1);imshow(img);%img=原圖
img1 = double(img(:,:,1));
[frameHeight, frameWidth, D] = size(img); %記影像長寬
%%
%這邊灑上約50%的雜訊0or255
for m=1:frameWidth
    for l=1:frameHeight
        p=rand(1);
        if p>0.75
            img1(l,m,:)=0;
        elseif p<0.25
            img1(l,m,:)=255;
        else
        end
    end
end
figure(2);imshow(uint8(img1));%img1=含雜訊原圖
%%
figure(3);imshow(uint8(medfilt2(img1,[7,7])));%引用內建函式庫7*7中值濾波
%這邊是中值濾波s=2,5*5 s=3,7*7
s=3;
for m=1+s:frameWidth-s
    for l=1+s:frameHeight-s
        i=0;
        for x=m-s:m+s
            for y=l-s:l+s
                i=i+1;
                A(i)=img1(y,x);
            end
        end
        img2(l-s,m-s,:)=median(A);
    end
end
figure(4);imshow(uint8(img2));%img2=雜訊圖7*7中值濾波
%%
%這邊更厲害
for m=5:frameWidth-5
    for l=5:frameHeight-5
    s=1;
        while s>0
            i=1;
            A=[];
            for x=m-s:m+s
                for y=l-s:l+s              
                    A(i)=img1(y,x);
                    i=i+1;
                end
            end
            med=median(A);
            a1=med-min(A);
            a2=med-max(A);
            if a1>0 && a2<0
                s=0;
            else
                s=s+1;
                if s>frameWidth
                    img3(y-4,x-4)=img1(y,x);
                    s=0;
                end
            end
        end
        b1=img1(l,m)-min(A);
        b2=img1(l,m)-max(A);
        if b1>0 && b2<0
            img3(l-4,m-4)=img1(l,m);
        else
            img3(l-4,m-4)=med;
        end
    end
end
figure(5);imshow(uint8(img3));%img3=自適應濾波器(作業要求方法)