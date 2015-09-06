a=[1,2,3,4,5]
b=[[1,2],[3,0],[4,5,'']]


c=[]
b.map do |item|
  item.delete('')
  c.push(item)
end
p c
