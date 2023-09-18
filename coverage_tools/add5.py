# for p in path:
    # fw = open(path)
path = input()
with open(path) as f:
    for s_line in f:
        # print(int(s_line.strip(),16)-1)
        print(hex(int(s_line.strip(),16)+5))
        # print(hex(1+int(s_line.strip())))