import os


def rename(directory, ext, prefix):
    os.chdir(directory)
    files = [ f for f in os.listdir('.') if os.path.isfile(os.path.join('.',f)) and f.endswith(ext) ]
    for i, file in enumerate(sorted(files)):
        os.rename(file, (prefix + '%d' + ext) % i)

if __name__ == '__main__':
    directory = input("Provide the path of the directory where your images are:   ")
    prefix = input("Provide the prefix or 'name' you want for your images:    ")
    ext = input("Provide the file extension of your images. Ex: .png, .jpg:  ")
    rename(directory, ext, prefix)
