db = null

    
class DB
    reset: ()=>
        @nodes = []
        @connections = []
        @groups = []
        @id = null

    loadFromJson: (json)=>
        @reset()
        
        @id = json.id
        @nodes = json.nodes
        @groups = json.groups
        @connections = json.connections

    
    updateProperty: (param)=>
        # no need to update connections
        param.groups.map((gParam)=>
            g = @groups.find((_g)=>
                return _g.id == gParam.get('id')
            )
            g.x = gParam.get('x')
            g.y = gParam.get('y')
            g.width = gParam.get('width')
            g.height = gParam.get('height')
        , @)

        param.nodes.map((nParam)=>
            n = @nodes.find((_n)=>
                return _n.id == nParam.id
            )
            n.x = nParam.get('x')
            n.y = nParam.get('y')
            n.width = nParam.get('width')
            n.height = nParam.get('height')
        , @)

    calculatePos: (nodes) ->
        min_x = 0
        min_y = 0
        max_x = 0
        max_y = 0
        for node in nodes
            min_x = Math.min(min_x, node.get("x"))
            max_x = Math.max(max_x, node.get("x"))
            min_y = Math.min(min_y, node.get("y"))
            max_y = Math.max(max_y, node.get("y"))

        dx = (min_x + max_x) / 2
        dy = (min_y + max_y) / 2
        return {x: dx, y: dy}


    createGroup: (nodes, index)=>
        pos = @calculatePos(nodes)
        nodesObj = nodes.map((n)=>
            return n.toJSON()
        )
        @groups.push({
            id: index
            x: pos.x
            y: pos.y
            width: 90
            height: 26
            nodes: nodesObj
        })


        @nodes = @nodes.filter((n)->
            nodeIds = nodes.map((_n)->
                return _n.id
            )
            return !nodeIds.includes(n.id)
        ,@)

        
        


    dump: ()=>
        return {
            id: @id
            nodes: @nodes
            groups: @groups
            connections: @connections
        }

    @getInstance = ()=>
        if(!db)
            db = new DB()
        return db

module.exports = DB
